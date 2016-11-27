//
//  ImageEditingViewController.m
//  Parodize
//
//  Created by administrator on 18/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "ImageEditingViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import "ChooseRecipientViewController.h"
#import "FilterCollectionCell.h"
#import "UIImage+Scale.h"
#import <QuartzCore/QuartzCore.h>

#import "GPUImage.h"
#import "PECropViewController.h"

#import "PenViewController.h"

//OpenGL

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "Imaging.h"

#define DEG2RAD (M_PI/180.0f)

#define RAD2DEG (180.0f/M_PI)

typedef enum _EditChoice {
    editBrightness,
    editContrast,
    editHue,
    editSaturation
}editChoice;

@interface ImageEditingViewController ()
{
    AppDelegate *appDelegate;
    NSString *tagsStr;
    
    NSArray *multiFilters;
    
    BOOL isColor;
    BOOL isFilter;
    BOOL isEdited;
    
    NSNumber *eventChoice;
    
    
    
    NSMutableArray *filtersArray;
    
    UIImage *final_image;
    UIImage *tempImage;
    UIImage *filterImage;
    
    UIImage *originalImage;
    
    UIImageView *prevImageView;
    CGRect prevFrame;
}
@end

@implementation ImageEditingViewController

@synthesize snapImage,snapImageView,doneButton,cancelButton,captionTextField,tagsTextField,getImage,colorButton,filterButton,cropButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //  self.hidesBottomBarWhenPushed = YES;
    self.toolBar.clipsToBounds = YES;
    
    // self.toolBar.hidden=YES;
    self.filterScrollView.hidden=YES;
    
    //    cancelButton.enabled=NO;
    //    self.cropButton.enabled=NO;
    //    [self.cropButton setTintColor: [UIColor clearColor]];
    //    self.filterButton.enabled=NO;
    //     [self.filterButton setTintColor: [UIColor clearColor]];
    //    self.colorButton.enabled=NO;
    //     [self.colorButton setTintColor: [UIColor clearColor]];
    
    //    CGRect viewRect=self.view.bounds;
    //
    //    viewRect.size.height.
    
    //    snapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.toolBar.frame.origin.y-40)];
    //
    //    snapImageView.contentMode=UIViewContentModeScaleAspectFill;
    //
    //
    //    //snapImageView.backgroundColor=[UIColor whiteColor];
    //
    //    [self.view addSubview:snapImageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.brightSlider addGestureRecognizer:doubleTap];
    
    self.brightSlider.layer.cornerRadius=1.0f;
    self.brightSlider.layer.borderColor=[UIColor whiteColor].CGColor;
    self.brightSlider.layer.borderWidth=1.0f;
    self.brightSlider.layer.masksToBounds=YES;
    
    tempImage=appDelegate.getNewImage;
    
    originalImage=appDelegate.getNewImage;
    
    [snapImageView setImage:tempImage];
    filtersArray=[[NSMutableArray alloc]init];
    [filtersArray addObject:[GPUImageGrayscaleFilter class]];
    [filtersArray addObject:[GPUImageSepiaFilter class]];
    [filtersArray addObject:[GPUImagePixellateFilter class]];
    [filtersArray addObject:[GPUImageColorInvertFilter class]];
    [filtersArray addObject:[GPUImageToonFilter class]];
    [filtersArray addObject:[GPUImagePinchDistortionFilter class]];
    //    [filtersArray addObject:[GPUImageFilter class]];
    //    [filtersArray addObject:[GPUImageMonochromeFilter class]];
    [filtersArray addObject:[GPUImageHazeFilter class]];
    [filtersArray addObject:[GPUImageThresholdEdgeDetectionFilter class]];
    [filtersArray addObject:[GPUImageHueFilter class]];
    [filtersArray addObject:[GPUImageGammaFilter class]];
    //    [filtersArray addObject:[GPUImageColorPackingFilter class]];
    [filtersArray addObject:[GPUImageCrosshatchFilter class]];
    //    [filtersArray addObject:[GPUImageKuwaharaFilter class]];
    [filtersArray addObject:[GPUImagePolarPixellateFilter class]];
    [filtersArray addObject:[GPUImageSketchFilter class]];
    
    getImage=[tempImage scaleToSize:CGSizeMake(100, 100)];
    
    
    __block UIImage *backImage;
    
    for (int i = 0; i < [filtersArray count]; i++)
    {
        CGFloat xOrigin = (i*100)+10;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        [imageView setFrame:CGRectMake(xOrigin, 30,80,80)];
        
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterImageTouched:)];
        [singleTap setNumberOfTapsRequired:1];
        
        [imageView addGestureRecognizer:singleTap];
        
        imageView.tag=i;
        
        imageView.userInteractionEnabled=YES;
        //UIImage *backImage=[self getFilterImage:[filtersArray objectAtIndex:i]];
        
        //        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
        //                       {
        // Background work
        backImage=[self getFilterImage:[filtersArray objectAtIndex:i] forImage:getImage];
        //                           dispatch_async(dispatch_get_main_queue(), ^(void)
        //                                          {
        // Main thread work (UI usually)
        [imageView setImage:backImage];
        
        
        
        
        //                                          });
        //                       });
        
        //[imageView setImage:backImage];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        imageView.alpha=1;
        
        [self.filterScrollView addSubview:imageView];
        
        imageView=nil;
    }
    
    [self.filterScrollView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
    [self.filterScrollView setContentSize:CGSizeMake(100 * [filtersArray count], self.filterScrollView.frame.size.height)];
    
    // [self.view bringSubviewToFront:self.filterScrollView];
    
    
    
    captionTextField.clipsToBounds = YES;
    captionTextField.layer.cornerRadius = 2.0f;
    
    tagsTextField.clipsToBounds = YES;
    tagsTextField.layer.cornerRadius = 2.0f;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillShown:)
    //                                                 name:UIKeyboardWillShowNotification
    //                                               object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillHide:)
    //                                                 name:UIKeyboardWillHideNotification
    //                                               object:nil];
    
    // self.colorContainer.hidden=YES;
    
    // [self.view bringSubviewToFront:self.colorContainer];
    
    [self.colorContainer setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
    [self.brightSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.contrastSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.saturationSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.hueSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.sharpSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.brightSlider addTarget:self
                          action:@selector(sliderDidEndSliding:)
                forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [self.contrastSlider addTarget:self
                            action:@selector(sliderDidEndSliding:)
                  forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [self.saturationSlider addTarget:self
                              action:@selector(sliderDidEndSliding:)
                    forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [self.hueSlider addTarget:self
                       action:@selector(sliderDidEndSliding:)
             forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [self.sharpSlider addTarget:self
                         action:@selector(sliderDidEndSliding:)
               forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)filterImageTouched:(id)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    UIImageView *imageView = (UIImageView *)recognizer.view;
    
    if (prevImageView  != imageView) {
        
        //   // [imageView setImage:[UIImage imageNamed:@"anyImage.png"]];
        //    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
        //                   {
        // Background work
        UIImage *backImage=[self getFilterImage:[filtersArray objectAtIndex:imageView.tag] forImage:tempImage];
        //                       dispatch_async(dispatch_get_main_queue(), ^(void)
        //                                      {
        // Main thread work (UI usually)
        [snapImageView setImage:backImage];
        filterImage=backImage;
        
        imageView.layer.borderColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR].CGColor;
        imageView.layer.borderWidth=2.0f;
        imageView.layer.masksToBounds=YES;
        
        prevImageView.layer.borderColor=[UIColor clearColor].CGColor;
        prevImageView.layer.masksToBounds=YES;
        
        prevImageView=imageView;
        
        isEdited=YES;
    }
    //                                      });
    //                   });
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)animateWhileEdit:(BOOL)isEdit {
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.2];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationDelegate:self];
    //
    //
    //
    //    CGRect frame = snapImageView.frame;
    //    if (isEdit) {
    //
    //        [UIView setAnimationDidStopSelector:@selector(editCallback:)];
    //
    //        self.editButton.enabled=NO;
    //        prevFrame=snapImageView.frame;
    //         tagsTextField.hidden=YES;
    //
    //        frame.size=CGSizeMake(snapImageView.frame.size.width, self.filterScrollView.frame.origin.y);
    //
    //    }else
    //    {
    //        [UIView setAnimationDidStopSelector:@selector(editCancelCallback:)];
    //
    //
    //        self.editButton.enabled=YES;
    //        self.filterScrollView.hidden=YES;
    //        self.toolBar.hidden=YES;
    //
    //        frame.size=CGSizeMake(prevFrame.size.width, prevFrame.size.height);
    //    }
    //
    //    snapImageView.frame = frame;
    //
    //
    //    [UIView commitAnimations];
    
    if (isEdit) {
        cancelButton.enabled=YES;
        
        [self.cropButton setTintColor: nil];
        
        [self.filterButton setTintColor: nil];
        
        [self.colorButton setTintColor: nil];
        
        self.cropButton.enabled=YES;
        self.filterButton.enabled=YES;
        self.colorButton.enabled=YES;
        
        self.editButton.enabled=NO;
        //  self.toolBar.hidden=NO;
        tagsTextField.hidden=YES;
        
    }else{
        //  self.toolBar.hidden=YES;
        tagsTextField.hidden=NO;
        
        cancelButton.enabled=NO;
        
        self.cropButton.enabled=NO;
        [self.cropButton setTintColor: [UIColor clearColor]];
        
        self.filterButton.enabled=NO;
        [self.filterButton setTintColor: [UIColor clearColor]];
        
        self.colorButton.enabled=NO;
        [self.colorButton setTintColor: [UIColor clearColor]];
    }
    
}

-(void)editCallback:(id)sender{
    
    self.filterScrollView.hidden=NO;
    self.toolBar.hidden=NO;
    
}
-(void)editCancelCallback:(id)sender{
    
    tagsTextField.hidden=NO;
    
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    
    self.editButton.enabled=NO;
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    
    
    //    const int movementDistance = 260; // tweak as needed
    const float movementDuration = 0.35f; // tweak as needed
    
    //int movement = (up ? -height : height);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, -height);
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.editButton.enabled=YES;
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    
    
    //    const int movementDistance = 260; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    //int movement = (up ? -height : height);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, height);
    [UIView commitAnimations];
}

- (IBAction)cacelAction:(id)sender
{
    if (isEdited) {
        isEdited=NO;
        
        UIAlertController *alert = [[UIAlertController alloc] init];
        //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"More" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *forgetWatchAction = [UIAlertAction actionWithTitle:@"Discard changes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.view endEditing:YES];
            
            [self cancellingEdit];
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:forgetWatchAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self cancellingEdit];
    }
    
}
-(void)cancellingEdit
{
    [self openOptionsView:NO];
    self.snapImageView.image=nil;
    self.snapImageView.image=[appDelegate getNewImage];
    
    //    self.toolBar.hidden=YES;
    
    cancelButton.enabled=NO;
    // self.cropButton.enabled=NO;
    // [self.cropButton setTintColor: [UIColor clearColor]];
    // self.filterButton.enabled=NO;
    // [self.filterButton setTintColor: [UIColor clearColor]];
    // self.colorButton.enabled=NO;
    // [self.colorButton setTintColor: [UIColor clearColor]];
}

- (IBAction)doneAction:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Tags"
                                                                              message: @"Please add tags to this mock"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Tags saperated by comma";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //  textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        
        [self doneWithMocking:namefield.text];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self doneWithMocking:nil];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    ///////
    
    
}


-(void)doneWithMocking:(NSString *)tagsString
{
    [self.view endEditing:YES];
    
    tagsStr=tagsString;
    
    [self performSegueWithIdentifier:@"doneSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"doneSegue"])
    {
        
        ChooseRecipientViewController *destViewController = segue.destinationViewController;
        
        destViewController.getImage=self.snapImageView.image;
        
        destViewController.tagsList = tagsStr;
    }else if ([segue.identifier isEqualToString:@"penSegue"]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDrawImage:)
                                                     name:@"DrawImage"
                                                   object:nil];

        
        PenViewController *destViewController = segue.destinationViewController;
        
        [destViewController setGetImage:snapImageView.image];
        
    }
    
}
-(void)getDrawImage:(NSNotification *) notification{
    
    UIImage *editImage=notification.object;
    
    [snapImageView setImage:editImage];
    
}
//-(UIImage*)PixellateFilter:(UIImage*)theImage withPixellateFilter:(GPUImagePixellateFilter *) pixellateFilter andStaticPicture:(GPUImagePicture *)staticPicture{
//    [staticPicture removeAllTargets];
//    UIImage __block *imageToReturn;
//    [staticPicture addTarget:pixellateFilter];
//    [staticPicture processImageWithCompletionHandler:^{
//        [pixellateFilter prepareForImageCapture];
//        imageToReturn = [pixellateFilter imageFromCurrentlyProcessedOutput];
//        [pixellateFilter removeAllTargets];
//        pixellateFilter = nil;
//    }];
//    return imageToReturn;
//}

-(UIImage *)getFilterImage:(id)imageFilter forImage:(UIImage *)image
{
    
    GPUImageFilter *filter=[[imageFilter alloc]init];
    
    UIImage *filteredImage = [filter imageByFilteringImage:image];
    
    return filteredImage;
    
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    NSLog(@"%@",self.snapImageView);
    
    isEdited=YES;
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    // [self keepMySnapImageConstant];
    
    tempImage=croppedImage;
    
    snapImageView.image = tempImage;
    
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    NSLog(@"%@",self.snapImageView);
    
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    // [self keepMySnapImageConstant];
}


- (IBAction)cropAction:(UIBarButtonItem *)button {
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = snapImageView.image;
    controller.title=@"Crop";
    
    UIImage *image = snapImageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    navigationController.navigationBar.translucent = false;
    navigationController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)filterAction:(UIBarButtonItem *)button {
    if (!isFilter) {
        isFilter=YES;
        [self openOptionsView:YES];
        isColor=NO;
        //        [button setImage:[UIImage imageNamed:@"multicolor_square"]];
        //        [cropButton setImage:[UIImage imageNamed:@"crop_image_filled"]];
        //        [colorButton setImage:[UIImage imageNamed:@"brightness_filled"]];
        
        [button setTintColor: [UIColor whiteColor]];
        
        [cropButton setTintColor: nil];
        
        [colorButton setTintColor: nil];
        
        self.colorContainer.hidden=YES;
        
    }else{
        [self openOptionsView:NO];
        isFilter=NO;
        // [button setImage:[UIImage imageNamed:@"multicolor_filled"]];
        
        [button setTintColor: nil];
    }
}
-(void)openOptionsView:(BOOL)isEdit
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    
    
    
    CGRect frame = snapImageView.frame;
    if (isEdit) {
        
        [UIView setAnimationDidStopSelector:@selector(editCallback:)];
        
        self.editButton.enabled=NO;
        prevFrame=snapImageView.frame;
        
        frame.size=CGSizeMake(snapImageView.frame.size.width, self.filterScrollView.frame.origin.y);
        
    }else
    {
        [UIView setAnimationDidStopSelector:@selector(editCancelCallback:)];
        
        self.editButton.enabled=YES;
        self.filterScrollView.hidden=YES;
        self.colorContainer.hidden=YES;
        [self.filterButton setImage:[UIImage imageNamed:@"multicolor_filled"]];
        [self.colorButton setImage:[UIImage imageNamed:@"brightness_filled"]];
        isColor=NO;
        isFilter=NO;
        frame.size=CGSizeMake(prevFrame.size.width, prevFrame.size.height);
    }
    
    // snapImageView.frame = frame;
    
    
    [UIView commitAnimations];
}
- (IBAction)colorAction:(UIBarButtonItem *)button {
    if (!isColor) {
        
        //        if (filterImage) {
        //            tempImage=filterImage;
        //        }
        if (!eventChoice) {
            
            eventChoice=editBrightness;
        }
        
        isColor=YES;
        isFilter=NO;
        //        [button setImage:[UIImage imageNamed:@"Brightness_square"]];
        //        [filterButton setImage:[UIImage imageNamed:@"multicolor_filled"]];
        //        [cropButton setImage:[UIImage imageNamed:@"crop_image_filled"]];
        
        [button setTintColor: [UIColor whiteColor]];
        
        [cropButton setTintColor: nil];
        
        [filterButton setTintColor: nil];
        
        self.colorContainer.hidden=NO;
        self.filterScrollView.hidden=YES;
    }else{
        isColor=NO;
        //[button setImage:[UIImage imageNamed:@"brightness_filled"]];
        [button setTintColor: nil];
        
        self.colorContainer.hidden=YES;
    }
}
- (IBAction)editAction:(id)sender {
    
    [self animateWhileEdit:YES];
}

-(void)keepMySnapImageConstant
{
    CGRect rect=snapImageView.frame;
    
    rect.size=CGSizeMake(snapImageView.frame.size.width, self.filterScrollView.frame.origin.y);
    
    snapImageView.frame=rect;
}

//Multi Color Settings


- (IBAction)brightnessValue:(UISlider *)sender {
    
    int choice=[eventChoice intValue];
    
    NSLog(@"%f",sender.value);
    
    switch (choice) {
        case editBrightness :
            
            @autoreleasepool {
                
                
                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
                
                [brightnessFilter setBrightness:sender.value];
                [fx_image addTarget:brightnessFilter];
                [brightnessFilter useNextFrameForImageCapture];
                [fx_image processImage];
                final_image=nil;
                final_image = [brightnessFilter imageFromCurrentFramebuffer];
                final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
                self.snapImageView.image = final_image;
                
                brightnessFilter=nil;
                fx_image=nil;
            }
            
            
            break;
        case editContrast :
            @autoreleasepool {
                
                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
                
                [contrastFilter setContrast:sender.value];
                [fx_image addTarget:contrastFilter];
                [contrastFilter useNextFrameForImageCapture];
                [fx_image processImage];
                final_image=nil;
                final_image = [contrastFilter imageFromCurrentFramebuffer];
                final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
                self.snapImageView.image = final_image;
                
                contrastFilter=nil;
                fx_image=nil;
            }
            
            break;
        case editHue :
            @autoreleasepool {
                
                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageHueFilter *hueFilter = [[GPUImageHueFilter alloc] init];
                
                // CGFloat degree=sender.value*(RAD2DEG);
                
                [hueFilter setHue:sender.value];
                [fx_image addTarget:hueFilter];
                [hueFilter useNextFrameForImageCapture];
                [fx_image processImage];
                final_image=nil;
                final_image = [hueFilter imageFromCurrentFramebuffer];
                final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
                self.snapImageView.image = final_image;
                
                hueFilter=nil;
                fx_image=nil;
            }
            break;
        case editSaturation :
            @autoreleasepool {
                
                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
                
                [saturationFilter setSaturation:sender.value];
                [fx_image addTarget:saturationFilter];
                [saturationFilter useNextFrameForImageCapture];
                [fx_image processImage];
                final_image=nil;
                final_image = [saturationFilter imageFromCurrentFramebuffer];
                final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
                self.snapImageView.image = final_image;
                
                saturationFilter=nil;
                fx_image=nil;
            }
            break;
            
        default:
            break;
    }
    
}
-(void)sliderDidEndSliding:(id)sender
{
    NSLog(@"Bright slider released");
    
    tempImage=final_image;
    
    final_image=nil;
    
}
- (IBAction)contrastValue:(UISlider *)sender {
    @autoreleasepool {
        
        isEdited=YES;
        GPUImagePicture *fx_image;
        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        
        [contrastFilter setContrast:sender.value];
        [fx_image addTarget:contrastFilter];
        [contrastFilter useNextFrameForImageCapture];
        [fx_image processImage];
        final_image=nil;
        final_image = [contrastFilter imageFromCurrentFramebuffer];
        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
        self.snapImageView.image = final_image;
        
        contrastFilter=nil;
        fx_image=nil;
    }
    
}
- (IBAction)staurationValue:(UISlider *)sender {
    @autoreleasepool {
        isEdited=YES;
        GPUImagePicture *fx_image;
        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        
        [saturationFilter setSaturation:sender.value];
        [fx_image addTarget:saturationFilter];
        [saturationFilter useNextFrameForImageCapture];
        [fx_image processImage];
        final_image=nil;
        final_image = [saturationFilter imageFromCurrentFramebuffer];
        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
        self.snapImageView.image = final_image;
        
        saturationFilter=nil;
        fx_image=nil;
    }
}
- (IBAction)hueValue:(UISlider *)sender {
    @autoreleasepool {
        isEdited=YES;
        GPUImagePicture *fx_image;
        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
        
        GPUImageHueFilter *hueFilter = [[GPUImageHueFilter alloc] init];
        
        // CGFloat degree=sender.value*(RAD2DEG);
        
        [hueFilter setHue:sender.value];
        [fx_image addTarget:hueFilter];
        [hueFilter useNextFrameForImageCapture];
        [fx_image processImage];
        final_image=nil;
        final_image = [hueFilter imageFromCurrentFramebuffer];
        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
        self.snapImageView.image = final_image;
        
        hueFilter=nil;
        fx_image=nil;
    }
    
}
- (IBAction)sharpValue:(UISlider *)sender {
    @autoreleasepool {
        isEdited=YES;
        GPUImagePicture *fx_image;
        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
        
        GPUImageSharpenFilter *sharpFilter = [[GPUImageSharpenFilter alloc] init];
        
        [sharpFilter setSharpness:sender.value];
        [fx_image addTarget:sharpFilter];
        [sharpFilter useNextFrameForImageCapture];
        [fx_image processImage];
        final_image=nil;
        final_image = [sharpFilter imageFromCurrentFramebuffer];
        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
        self.snapImageView.image = final_image;
        
        sharpFilter=nil;
        fx_image=nil;
    }
    
}
- (IBAction)brightnessAction:(id)sender {
    eventChoice=[NSNumber numberWithInt:editBrightness];
    
    self.brightSlider.minimumValue = -1.0f;
    self.brightSlider.maximumValue = 1.0f;
    
    self.brightLabel.hidden=NO;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=YES;
}

- (IBAction)contrastAction:(id)sender {
    eventChoice=[NSNumber numberWithInt:editContrast];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 4.0f;
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=NO;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=YES;
}

- (IBAction)hueAction:(id)sender {
    eventChoice=[NSNumber numberWithInt:editHue];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 360.0f;
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=NO;
    self.saturationLabel.hidden=YES;
}

- (IBAction)saturationAction:(id)sender {
    
    eventChoice=[NSNumber numberWithInt:editSaturation];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 2.0f;
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=NO;
}
-(void)doDoubleTap:(id)sender
{
    NSLog(@"Double tap resetting value");
}
-(void)eventChoiceLabelHide
{
    
}

@end
