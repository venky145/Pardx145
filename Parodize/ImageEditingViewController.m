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
#import "AcceptSendViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GPUImageGrayscaleFilterOne.h"
#import "Imaging.h"
#import <math.h>

#define DEG2RAD (M_PI/180.0f)

#define RAD2DEG (180.0f/M_PI)

#define BRIGHTNESS_VALUE     @"Brightness"
#define CONTRAST_VALUE      @"Contrast"
#define HUE_VALUE           @"Hue"
#define SATURATION_VALUE    @"Saturation"


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
    BOOL isFiltered;
    
    NSNumber *eventChoice;
    NSMutableArray *filtersArray;
    
    UIImage *final_image;
    UIImage *tempImage;
    UIImage *filterImage;
    
    UIImage *originalImage;
    
    UIImageView *prevImageView;
    CGRect prevFrame;
    
    NSMutableDictionary *sliderValuesDict;
}
@end

@implementation ImageEditingViewController

@synthesize snapImage,snapImageView,doneButton,cancelButton,getImage,colorButton,filterButton,cropButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //  self.hidesBottomBarWhenPushed = YES;
    self.toolBar.clipsToBounds = YES;
    
    // self.toolBar.hidden=YES;
    self.filterScrollView.hidden=YES;
    self.colorContainer.hidden=YES;
    
    sliderValuesDict=[[NSMutableDictionary alloc]init];

    [sliderValuesDict setValue:[NSNumber numberWithInt:editBrightness] forKey:BRIGHTNESS_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editContrast] forKey:CONTRAST_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editHue] forKey:HUE_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editSaturation] forKey:SATURATION_VALUE];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.brightSlider addGestureRecognizer:doubleTap];
    
//    self.brightSlider.layer.cornerRadius=1.0f;
//    self.brightSlider.layer.borderColor=[UIColor whiteColor].CGColor;
//    self.brightSlider.layer.borderWidth=1.0f;
//    self.brightSlider.layer.masksToBounds=YES;
    
    tempImage=appDelegate.getNewImage;
    
    originalImage=appDelegate.getNewImage;
    
    [snapImageView setImage:tempImage];
    
//     [snapImageView setImage:[[Context contextSharedManager] imageWithImage:tempImage scaledToSize:self.view.frame.size]];
    
    filtersArray=[[NSMutableArray alloc]init];
    [filtersArray addObject:[GPUImageGrayscaleFilter class]];
    [filtersArray addObject:[GPUImageGrayscaleFilterOne class]];
    [filtersArray addObject:[GPUImageSepiaFilter class]];
    [filtersArray addObject:[GPUImageSketchFilter class]];
    [filtersArray addObject:[GPUImageGaussianSelectiveBlurFilter class]];
    [filtersArray addObject:[GPUImagePolkaDotFilter class]];
    [filtersArray addObject:[GPUImageEmbossFilter class]];
    [filtersArray addObject:[GPUImageToneCurveFilter class]];

  //  getImage=[tempImage scaleToSize:CGSizeMake(100, 100)];
    
    [self loadFilterImages];
    
    [self.colorContainer setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
//    [self.brightSlider setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
    
    [self.brightSlider addTarget:self
                          action:@selector(sliderDidEndSliding:)
                forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
//    [self cropAction:nil];
}
-(void)loadFilterImages{
    
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
        backImage=[self getFilterImage:[filtersArray objectAtIndex:i] forImage:getImage];
        [imageView setImage:backImage];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        imageView.alpha=1;
        
        [self.filterScrollView addSubview:imageView];
        
        imageView=nil;
    }
    
    [self.filterScrollView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
    [self.filterScrollView setContentSize:CGSizeMake(100 * [filtersArray count], self.filterScrollView.frame.size.height)];
    
}

-(void)filterImageTouched:(id)sender
{
    cancelButton.enabled=YES;
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    UIImageView *imageView = (UIImageView *)recognizer.view;
    
    if (prevImageView  != imageView) {
        UIImage *backImage=[self getFilterImage:[filtersArray objectAtIndex:imageView.tag] forImage:tempImage];
        
        [snapImageView setImage:backImage];
        
//        [snapImageView setImage:[[Context contextSharedManager] imageWithImage:backImage scaledToSize:snapImageView.frame.size]];
        
        //tempImage=backImage;
        
        filterImage=backImage;
        
        imageView.layer.borderColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR].CGColor;
        imageView.layer.borderWidth=2.0f;
        imageView.layer.masksToBounds=YES;
        
        prevImageView.layer.borderColor=[UIColor clearColor].CGColor;
        prevImageView.layer.masksToBounds=YES;
        
        prevImageView=imageView;
        
        isFiltered=YES;
        isEdited=YES;
    }
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

        
    }else{

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


- (IBAction)backAction:(id)sender {
    if (_isAccept) {
        [self.navigationController  popViewControllerAnimated:YES];
    }else{
         [self dismissViewControllerAnimated:YES completion:nil];
    }
   
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
    //[self openOptionsView:NO];
    self.snapImageView.image=nil;
    self.snapImageView.image=originalImage;
    getImage=originalImage;
    
    //    self.toolBar.hidden=YES;
    
    cancelButton.enabled=NO;
    // self.cropButton.enabled=NO;
    // [self.cropButton setTintColor: [UIColor clearColor]];
    // self.filterButton.enabled=NO;
     [self.filterButton setTintColor: [UIColor whiteColor]];
    // self.colorButton.enabled=NO;
     [self.colorButton setTintColor: [UIColor whiteColor]];
    
    self.filterScrollView.hidden=YES;
    self.colorContainer.hidden=YES;
    isColor=NO;
    isFilter=NO;
    //remove scroll view selected image border
    prevImageView.layer.borderColor=[UIColor clearColor].CGColor;
    prevImageView.layer.masksToBounds=YES;
}

- (IBAction)doneAction:(id)sender {
    
    
    [self.view endEditing:YES];

    if (_isAccept) {
        [self performSegueWithIdentifier:@"acceptSendSegue" sender:self];
    }else
        [self performSegueWithIdentifier:@"doneSegue" sender:self];
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Tags"
//                                                                              message: @"Please add tags to this mock"
//                                                                       preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Tags saperated by comma";
//        textField.textColor = [UIColor blackColor];
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        //  textField.borderStyle = UITextBorderStyleRoundedRect;
//    }];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSArray * textfields = alertController.textFields;
//        UITextField * namefield = textfields[0];
//        NSLog(@"%@",namefield.text);
//        
//        [self doneWithMocking:namefield.text];
//        
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
//        [self doneWithMocking:nil];
    
//    }]];
    
//    [self presentViewController:alertController animated:YES completion:nil];
    
    ///////
    
    
}


//-(void)doneWithMocking:(NSString *)tagsString
//{
//    [self.view endEditing:YES];
//    
//    tagsStr=tagsString;
//    if (_isAccept) {
//        [self performSegueWithIdentifier:@"acceptSendSegue" sender:self];
//    }else
//        [self performSegueWithIdentifier:@"doneSegue" sender:self];
//}
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
        
    }else if ([segue.identifier isEqualToString:@"acceptSendSegue"]){
        
                AcceptSendViewController *destViewController = segue.destinationViewController;
                destViewController.getImage = self.snapImageView.image;
                destViewController.acceptID = appDelegate.accpet_ID;
              //  destViewController.getMockImage=self.acceptImageView.image;
                destViewController.isAccept = YES;
    }

    
}
-(void)getDrawImage:(NSNotification *) notification{
    
    cancelButton.enabled=YES;
    isEdited=NO;
    
    UIImage *editImage=notification.object;
    
//    UIImageView *topLayer=[[UIImageView alloc]initWithImage:editImage];
//    topLayer.frame=self.snapImageView.frame;
//    
//    [snapImageView addSubview: topLayer];
//    
//    UIGraphicsBeginImageContextWithOptions(topLayer.frame.size, NO, 0.0); //retina res
//    [snapImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [topLayer.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    snapImageView.image=editImage;
    tempImage=editImage;
    if (isFilter) {
        [self loadFilterImages];
    }
    
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
        
        prevFrame=snapImageView.frame;
        
        frame.size=CGSizeMake(snapImageView.frame.size.width, self.filterScrollView.frame.origin.y);
        
    }else
    {
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
- (IBAction)filterAction:(UIBarButtonItem *)button {
    
    [self getEditedImage];
    if (!isFilter) {
        isFilter=YES;
        [self loadFilterImages];
        isColor=NO;
        [button setTintColor: nil];
        self.filterScrollView.hidden=NO;
        [colorButton setTintColor: [UIColor whiteColor]];
        self.colorContainer.hidden=YES;
    }else{
        //[self openOptionsView:NO];
        isFilter=NO;
        // [button setImage:[UIImage imageNamed:@"multicolor_filled"]];
        
        self.filterScrollView.hidden=YES;
        [button setTintColor: [UIColor whiteColor]];
    }
}

- (IBAction)colorAction:(UIBarButtonItem *)button {
  
    if (!isColor) {
        
        //        if (filterImage) {
        //            tempImage=filterImage;
        //        }
        if (!eventChoice) {
            
            eventChoice=editBrightness;
            [self brightnessAction:nil];
        }
        if (isFiltered) {
            tempImage=snapImageView.image;
            isFiltered=NO;
        }
        
        isColor=YES;
        isFilter=NO;
        //        [button setImage:[UIImage imageNamed:@"Brightness_square"]];
        //        [filterButton setImage:[UIImage imageNamed:@"multicolor_filled"]];
        //        [cropButton setImage:[UIImage imageNamed:@"crop_image_filled"]];
        
        [button setTintColor: nil];
        
        //[cropButton setTintColor: nil];
        
        [filterButton setTintColor: [UIColor whiteColor]];
        
        self.colorContainer.hidden=NO;
        self.filterScrollView.hidden=YES;
    }else{
        isColor=NO;
        //[button setImage:[UIImage imageNamed:@"brightness_filled"]];
        [button setTintColor: [UIColor whiteColor]];
        
        self.colorContainer.hidden=YES;
    }
}
//Multi Color Settings


- (IBAction)brightnessValue:(UISlider *)sender {
    
    cancelButton.enabled=YES;
    
    int choice=[eventChoice intValue];

    NSLog(@"%f",sender.value);
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",sender.value];
    
    
    switch (choice) {
        case editBrightness :
            
            @autoreleasepool {

//                isEdited=YES;
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
                NSLog(@"%f",[[sliderValuesDict objectForKey:BRIGHTNESS_VALUE] floatValue]);
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:BRIGHTNESS_VALUE];
            }
            break;
        case editContrast :
            @autoreleasepool {
                
//                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
                float hueValue = 0.0;
                
                if (sender.value>1) {
                    
//                    hueValue=sender.value*2;
                    hueValue = pow(sender.value, (log(sender.value*2)/log(2)));
                    NSLog(@"power....%f",hueValue);
                }else{
                    hueValue=sender.value;
                }
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
                NSLog(@"%f",[[sliderValuesDict objectForKey:CONTRAST_VALUE] floatValue]);
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:CONTRAST_VALUE];
            }
            
            break;
        case editHue :
            @autoreleasepool {
                
//                isEdited=YES;
                GPUImagePicture *fx_image;
                fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
                
                GPUImageHueFilter *hueFilter = [[GPUImageHueFilter alloc] init];
                
                // CGFloat degree=sender.value*(RAD2DEG);
                
                float hueValue = 0.0;
                
                if (sender.value<0) {
                    
                    hueValue=360.0f-sender.value;
                }else{
                    hueValue=sender.value;
                }
                
                [hueFilter setHue:hueValue];
                [fx_image addTarget:hueFilter];
                [hueFilter useNextFrameForImageCapture];
                [fx_image processImage];
                final_image=nil;
                final_image = [hueFilter imageFromCurrentFramebuffer];
                final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
                self.snapImageView.image = final_image;
                hueFilter=nil;
                fx_image=nil;
                NSLog(@"%f",[[sliderValuesDict objectForKey:HUE_VALUE] floatValue]);
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:HUE_VALUE];
            }
            break;
        case editSaturation :
            @autoreleasepool {
                
//                isEdited=YES;
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
                NSLog(@"%f",[[sliderValuesDict objectForKey:SATURATION_VALUE] floatValue]);
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:SATURATION_VALUE];
            }
            break;
            
        default:
            break;
    }
    
}
-(void)sliderDidEndSliding:(id)sender
{
    NSLog(@"Bright slider released");

    if (!isEdited) {
        isEdited=YES;
    }
    
}
//- (IBAction)contrastValue:(UISlider *)sender {
//    @autoreleasepool {
//        
//       // isEdited=YES;
//        GPUImagePicture *fx_image;
//        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
//        
//        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
//        
//        [contrastFilter setContrast:sender.value];
//        [fx_image addTarget:contrastFilter];
//        [contrastFilter useNextFrameForImageCapture];
//        [fx_image processImage];
//        final_image=nil;
//        final_image = [contrastFilter imageFromCurrentFramebuffer];
//        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
//        self.snapImageView.image = final_image;
//        
//        contrastFilter=nil;
//        fx_image=nil;
//    }
//    
//}
//- (IBAction)staurationValue:(UISlider *)sender {
//    @autoreleasepool {
//       // isEdited=YES;
//        GPUImagePicture *fx_image;
//        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
//        
//        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
//        
//        [saturationFilter setSaturation:sender.value];
//        [fx_image addTarget:saturationFilter];
//        [saturationFilter useNextFrameForImageCapture];
//        [fx_image processImage];
//        final_image=nil;
//        final_image = [saturationFilter imageFromCurrentFramebuffer];
//        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
//        self.snapImageView.image = final_image;
//        
//        saturationFilter=nil;
//        fx_image=nil;
//    }
//}
//- (IBAction)hueValue:(UISlider *)sender {
//    @autoreleasepool {
//        //isEdited=YES;
//        GPUImagePicture *fx_image;
//        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
//        
//        GPUImageHueFilter *hueFilter = [[GPUImageHueFilter alloc] init];
//        
//        // CGFloat degree=sender.value*(RAD2DEG);
//        
//        [hueFilter setHue:sender.value];
//        [fx_image addTarget:hueFilter];
//        [hueFilter useNextFrameForImageCapture];
//        [fx_image processImage];
//        final_image=nil;
//        final_image = [hueFilter imageFromCurrentFramebuffer];
//        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
//        self.snapImageView.image = final_image;
//        
//        hueFilter=nil;
//        fx_image=nil;
//    }
//    
//}
//- (IBAction)sharpValue:(UISlider *)sender {
//    
//    [self getEditedImage];
//    
//    @autoreleasepool {
//        //isEdited=YES;
//        GPUImagePicture *fx_image;
//        fx_image = [[GPUImagePicture alloc] initWithImage:tempImage];
//        
//        GPUImageSharpenFilter *sharpFilter = [[GPUImageSharpenFilter alloc] init];
//        
//        [sharpFilter setSharpness:sender.value];
//        [fx_image addTarget:sharpFilter];
//        [sharpFilter useNextFrameForImageCapture];
//        [fx_image processImage];
//        final_image=nil;
//        final_image = [sharpFilter imageFromCurrentFramebuffer];
//        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:tempImage.imageOrientation];
//        self.snapImageView.image = final_image;
//        
//        sharpFilter=nil;
//        fx_image=nil;
//    }
//    
//}

-(void)getEditedImage{
    if (isEdited) {
        if (final_image) {
            tempImage=final_image;
        }
        final_image=nil;
        isEdited=NO;
    }
}

- (IBAction)brightnessAction:(id)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editBrightness];
    
    self.brightSlider.minimumValue = -1.0f;
    self.brightSlider.maximumValue = 1.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:BRIGHTNESS_VALUE] floatValue]);
    self.brightSlider.value=[[sliderValuesDict objectForKey:BRIGHTNESS_VALUE] floatValue];
    
    self.brightLabel.hidden=NO;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=YES;
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
}

- (IBAction)contrastAction:(id)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editContrast];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 2.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:CONTRAST_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:CONTRAST_VALUE] floatValue];
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=NO;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=YES;
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
}

- (IBAction)hueAction:(id)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editHue];
    
    self.brightSlider.minimumValue = -180.0f;
    self.brightSlider.maximumValue = 180.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:HUE_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:HUE_VALUE] floatValue];
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=NO;
    self.saturationLabel.hidden=YES;
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
}

- (IBAction)saturationAction:(id)sender {
     [self getEditedImage];
    
    eventChoice=[NSNumber numberWithInt:editSaturation];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 2.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:SATURATION_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:SATURATION_VALUE] floatValue];
    
    self.brightLabel.hidden=YES;
    self.contrastLabel.hidden=YES;
    self.hueLabel.hidden=YES;
    self.saturationLabel.hidden=NO;
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
}
-(void)doDoubleTap:(id)sender
{
    NSLog(@"Double tap resetting value");
    float resultValue=0.0f;
//    float maxValue=_brightSlider.maximumValue;
    int choice=[eventChoice intValue];
    
    switch (choice) {
        case editBrightness:
            resultValue=0;
            break;
        case editContrast:
            resultValue=1;
            break;
        case editHue:
            resultValue=0;
            break;
        case editSaturation:
            resultValue=1;
            break;
            
        default:
            break;
    }
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
    [_brightSlider setValue:resultValue animated:YES];
    [self brightnessValue:_brightSlider];
}
-(void)eventChoiceLabelHide
{
    
}

@end
