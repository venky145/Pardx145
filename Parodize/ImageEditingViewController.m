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
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GPUImageGrayscaleFilterOne.h"
#import "AcceptCaptionViewController.h"
#import "Imaging.h"
#import "NewDoneViewController.h"
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
    BOOL isPen;
    
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
    
    GPUImageBrightnessFilter *brightnessFilter;
    GPUImageContrastFilter *contrastFilter;
    GPUImageHueFilter *hueFilter;
    GPUImageSaturationFilter *saturationFilter;
    
    GPUImageFilter *finalFilter;
    
    UIImage *modifiedImage;
    
    GPUImagePicture *gpuImage;

    GPUImageView *gpuImageView;
    
    NSArray *colorsArray;
    
    UICollectionViewCell *prevCell;
    
    //
    NSArray<Class>* instagramFilters;
    NSInteger _filterIndex;
    GPUImagePicture* stillImageSource;
    
    GPUImageRGBFilter *rgbfilter;
    GPUImageWhiteBalanceFilter *whilteFilter;
}

@end

@implementation ImageEditingViewController

@synthesize snapImage,snapImageView,doneButton,cancelButton,getImage,colorButton,filterButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.toolBar.clipsToBounds = YES;
    self.filterCollectionView.hidden=YES;
    self.colorContainer.hidden=YES;
    self.penColorView.hidden=YES;
    self.drawLineView.userInteractionEnabled=NO;
    self.undoButton.hidden=YES;
    
    colorsArray=[[NSArray alloc]initWithObjects:[UIColor whiteColor],[UIColor blackColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    
    sliderValuesDict=[[NSMutableDictionary alloc]init];

    [sliderValuesDict setValue:[NSNumber numberWithInt:editBrightness] forKey:BRIGHTNESS_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editContrast] forKey:CONTRAST_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editHue] forKey:HUE_VALUE];
    [sliderValuesDict setValue:[NSNumber numberWithInt:editSaturation] forKey:SATURATION_VALUE];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.brightSlider addGestureRecognizer:doubleTap];
    
    tempImage=appDelegate.getNewImage;
    
    originalImage=appDelegate.getNewImage;
    
    [snapImageView setImage:tempImage];
    
    filtersArray=[[NSMutableArray alloc]init];
    [filtersArray addObject:[GPUImageRGBFilter class]];
    [filtersArray addObject:[GPUImageWhiteBalanceFilter class]];
    [filtersArray addObject:[GPUImageMonochromeFilter class]];
    [filtersArray addObject:[GPUImageAmatorkaFilter class]];
    [filtersArray addObject:[GPUImageGrayscaleFilter class]];
    [filtersArray addObject:[GPUImageSepiaFilter class]];
    [filtersArray addObject:[GPUImageSketchFilter class]];
    [filtersArray addObject:[GPUImageGaussianSelectiveBlurFilter class]];
    [filtersArray addObject:[GPUImagePolkaDotFilter class]];
    [filtersArray addObject:[GPUImageEmbossFilter class]];
    [self loadFilterImages];

    [self.brightSlider addTarget:self
                          action:@selector(sliderEnds:)
            forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    contrastFilter = [[GPUImageContrastFilter alloc] init];
    hueFilter = [[GPUImageHueFilter alloc] init];
    saturationFilter = [[GPUImageSaturationFilter alloc] init];
    finalFilter=[[GPUImageFilter alloc]init];
    rgbfilter = [[GPUImageRGBFilter alloc] init];
    whilteFilter = [[GPUImageWhiteBalanceFilter alloc]init];
    
//    stillImageSource = [[GPUImagePicture alloc] init];

    [self cropAction];
    
//    [self colorAction:colorButton];

}
-(void)gpuImageSetUp{
    gpuImage=nil;
    gpuImageView=nil;
    gpuImageView = [[GPUImageView alloc] init];
    gpuImageView.fillMode=kGPUImageFillModePreserveAspectRatioAndFill;
//    if (!_isImagePicker) {
//        if (_isCameraFront) {
//            [gpuImageView setInputRotation:kGPUImageRotateRightFlipVertical atIndex:0];
//        }else{
//            [gpuImageView setInputRotation:kGPUImageRotateRight atIndex:0];
//        }
//        
//    }
    gpuImage = [[GPUImagePicture alloc] initWithImage:tempImage];
    [gpuImage addTarget:finalFilter];
    [finalFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:contrastFilter];
    [contrastFilter addTarget:hueFilter];
    [hueFilter addTarget:saturationFilter];
//    [saturationFilter addTarget:gpuImageView];
    [saturationFilter addTarget:rgbfilter];
    [rgbfilter addTarget:whilteFilter];
    [whilteFilter addTarget:gpuImageView];
    
    hueFilter.hue = 0.0;
    finalFilter=hueFilter;
    
    [gpuImage processImage];

}

- (void)viewDidAppear:(BOOL)animated{
    
    gpuImageView.frame=snapImageView.frame;
    [self.mainContainerView addSubview:gpuImageView];
    [self.mainContainerView bringSubviewToFront:self.drawLineView];
}
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)loadFilterImages{
    
    getImage=tempImage;
    
    __block UIImage *backImage;
    
    for (int i = 0; i < [filtersArray count]; i++)
    {
        CGFloat xOrigin = (i*(105))+10;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        [imageView setFrame:CGRectMake(xOrigin, 0,100,100)];
        
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterImageTouched:)];
        [singleTap setNumberOfTapsRequired:1];
        
        [imageView addGestureRecognizer:singleTap];
        
        imageView.tag=i;
        
        imageView.userInteractionEnabled=YES;
        backImage=[self getFilterImage:[filtersArray objectAtIndex:i] forImage:getImage];
        [imageView setImage:backImage];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds=YES;
        imageView.layer.cornerRadius=imageView.frame.size.height/2;
        imageView.layer.borderColor=[[Context contextSharedManager] colorWithRGBHex:UPPER_COLOR].CGColor;
        imageView.layer.borderWidth=2.0f;
        imageView.layer.masksToBounds=YES;
        
//        imageView.alpha;
        
//        GPUImageView  *gpuView =[[GPUImageView alloc]initWithFrame:imageView.frame];
//        GPUImagePicture *pictureView=[[GPUImagePicture alloc]initWithImage:getImage];
//        
//        GPUImageHSBFilter *rgb=[[GPUImageHSBFilter alloc]init];
//        [rgb adjustBrightness:0.111111];
//        [rgb adjustSaturation:1.673203];
//        [rgb rotateHue:5.294117];
//        
//        
//        [pictureView addTarget:rgb];
//        [rgb addTarget:gpuView];
        
//        [self.filterScrollView addSubview:imageView];
        
      imageView=nil;
   
      /*     Brightness: 0.111111
         Contrast: 1.790850
         Hue : -5.294117
         Saturation: 1.673203
         
         Second:
         
         Brightness : 0.183007
         Contrast : 2.000000
         Hue : -0.588235
         Saturation : 1.382353
         
         Third :
         
         Brightness : 0.741830
         Contrast : 1.176471
         Hue : 1.696078
         Saturation : -0.058824
         
         Fourth :
         
         Brightness : -0.062092
         Contrast : 1.248366
         Hue : -1.764706
         Saturation : 1.656863
    */
    }
    
//    [self.filterScrollView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
//    [self.filterScrollView setContentSize:CGSizeMake(120 * [filtersArray count], self.filterScrollView.frame.size.height)];
    
 /*   stillImageSource = nil;
    stillImageSource=[[GPUImagePicture alloc]initWithImage:getImage];
   
    
   
    
//    _filterIndex = 0;
    instagramFilters = [IFImageFilter allFilterClasses];
    
//    NSInteger filterIndex = (_filterIndex++ % instagramFilters.count);
    
    [stillImageSource removeAllTargets];
    
    
    
    for (int i = 0; i < 3; i++)
    {
        CGFloat xOrigin = (i*(105))+10;
        
         gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, 100, 100)];
        
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterImageTouched:)];
        [singleTap setNumberOfTapsRequired:1];
        
        [gpuImageView addGestureRecognizer:singleTap];
        
        gpuImageView.tag=i;
        
        gpuImageView.userInteractionEnabled=YES;
        
        IFImageFilter *imageFilter = [[[instagramFilters objectAtIndex:i] alloc] init];
        [imageFilter addTarget:gpuImageView];
        
        [stillImageSource addTarget:imageFilter];
        
        [imageFilter useNextFrameForImageCapture];
        [stillImageSource processImage];
        
        [imageFilter imageFromCurrentFramebuffer];
        
        [self.filterScrollView addSubview:gpuImageView];
    }
  */
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)editCallback:(id)sender{
    
    self.filterCollectionView.hidden=NO;
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
   /* if (isEdited) {
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
 */
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)cancellingEdit
{
    
//    brightnessFilter.brightness = 0;
//    finalFilter=brightnessFilter;
//    [gpuImage processImage];
//    [sliderValuesDict setValue:[NSNumber numberWithFloat:0] forKey:BRIGHTNESS_VALUE];
//    
//    contrastFilter.contrast = 1;
//    finalFilter=contrastFilter;
//    [gpuImage processImage];
//    [sliderValuesDict setValue:[NSNumber numberWithFloat:1] forKey:CONTRAST_VALUE];
//    
//    hueFilter.hue = 0;
//    finalFilter=hueFilter;
//    [gpuImage processImage];
//    [sliderValuesDict setValue:[NSNumber numberWithFloat:0] forKey:HUE_VALUE];
//    
//    saturationFilter.saturation = 1;
//    finalFilter=saturationFilter;
//    [gpuImage processImage];
//    [sliderValuesDict setValue:[NSNumber numberWithFloat:1] forKey:HUE_VALUE];
    
    
    for (int i=0; i<=3; i++) {
        if (i==4) {
            [self brightnessAction:_brightButton];
        }else{
            
            eventChoice = [NSNumber numberWithInt:i];
            [self doDoubleTap:nil];

        }
    }
    
//        int choice=[eventChoice intValue];
//        
//        switch (choice) {
//            case editBrightness:
//                resultValue=0;
//                break;
//            case editContrast:
//                resultValue=1;
//                break;
//            case editHue:
//                resultValue=0;
//                break;
//            case editSaturation:
//                resultValue=1;
//                break;
//            default:
//                break;
//        }
//        self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
//        [_brightSlider setValue:resultValue animated:YES];
//        [self brightnessValue:_brightSlider];
//        }
//    }
    

    
   /*
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
    */
}
//-(UIImage *)mergePenTool{
//    
//    UIGraphicsBeginImageContext(firstImage.size);
//    [firstImage drawAtPoint:CGPointMake(0,0)];
//    [secondImage drawAtPoint:CGPointMake(0,0)];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    resultImage = UIGraphicsGetImageFromCurrentImageContext(); //taking the merged result from context, in a new Image. This is your required image.
//    
//    UIGraphicsEndImageContext();
//}
- (IBAction)doneAction:(id)sender {
    
    [self.view endEditing:YES];

    if (_isAccept) {
        [self performSegueWithIdentifier:@"acceptSuccess" sender:self];
    }else if(_isPlayGround||_isPGResponse){
        NSLog(@"PlayGround");
         [self performSegueWithIdentifier:@"pgDoneSegue" sender:self];
        
    }else if(_isFriend){
        [self performSegueWithIdentifier:@"pgDoneSegue" sender:self];
        
    }else{
        [self performSegueWithIdentifier:@"doneSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [finalFilter useNextFrameForImageCapture];
    [gpuImage processImage];
    UIImage *filteredImage=[finalFilter imageFromCurrentFramebuffer];
    
    if ([segue.identifier isEqualToString:@"doneSegue"])
    {
        
        ChooseRecipientViewController *destViewController = segue.destinationViewController;
//        destViewController.getImage=filteredImage;

        destViewController.getImage=[self contextCurrentImage];
        destViewController.tagsList = tagsStr;
    }else if ([segue.identifier isEqualToString:@"penSegue"]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDrawImage:)
                                                     name:@"DrawImage"
                                                   object:nil];

        PenViewController *destViewController = segue.destinationViewController;
        
        [destViewController setGetImage:snapImageView.image];
        
    }else if ([segue.identifier isEqualToString:@"acceptSuccess"]){
        AcceptCaptionViewController *destViewController = segue.destinationViewController;
        destViewController.mockImage=filteredImage;
    }else if ([segue.identifier isEqualToString:@"pgDoneSegue"])
    {
        
        NewDoneViewController *destViewController = segue.destinationViewController;
        if (_isPlayGround) {
            destViewController.isPlayGround=YES;
            destViewController.isPGResponse=NO;
        }else if(_isFriend){
            destViewController.isPGResponse=NO;
            destViewController.isPlayGround=NO;
            destViewController.isFriend=YES;
        }
        else{
            destViewController.isPGResponse=YES;
            destViewController.isPlayGround=NO;
        }
        destViewController.mockImage=filteredImage;
    }
}
-(UIImage *)contextCurrentImage{
    UIGraphicsBeginImageContextWithOptions(self.mainContainerView.frame.size, NO, 0.0);
    
    [self.mainContainerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *answer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return answer;
}
-(void)getDrawImage:(NSNotification *) notification{
    
    cancelButton.enabled=YES;
    isEdited=NO;
    
    UIImage *editImage=notification.object;
    snapImageView.image=editImage;
    tempImage=editImage;
    if (isFilter) {
        [self loadFilterImages];
    }
    
}
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
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    // [self keepMySnapImageConstant];
    
    tempImage=croppedImage;
    
    snapImageView.image = tempImage;
    
    [self gpuImageSetUp];
    [self colorAction:colorButton];
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    NSLog(@"%@",self.snapImageView);
    
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    // [self keepMySnapImageConstant];
}


- (void)cropAction{
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originalImage;
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
        
        frame.size=CGSizeMake(snapImageView.frame.size.width, self.filterCollectionView.frame.origin.y);
        
    }else
    {
        self.filterCollectionView.hidden=YES;
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
        isPen=NO;
        [button setTintColor: [UIColor whiteColor]];
        self.filterCollectionView.hidden=NO;
        self.colorContainer.hidden=YES;
        self.penColorView.hidden=YES;
        [button setImage:[UIImage imageNamed:@"filter_selected"]];
        [colorButton setImage:[UIImage imageNamed:@"brightness_tool"]];
        [_penButton setImage:[UIImage imageNamed:@"pentool_icon"]];
    }else{
        isFilter=NO;
         [button setImage:[UIImage imageNamed:@"filter_icon"]];
        
        self.filterCollectionView.hidden=YES;
        [button setTintColor: [UIColor whiteColor]];
    }
}

- (IBAction)colorAction:(UIBarButtonItem *)button {
    
    if (!isColor) {
        if (!eventChoice) {
            eventChoice=editBrightness;
            [self brightnessAction:_brightButton];
        }
        if (isFiltered) {
            tempImage=snapImageView.image;
            isFiltered=NO;
        }
        
        isColor=YES;
        isFilter=NO;
        isPen=NO;
        [button setImage:[UIImage imageNamed:@"brightness_tool_selected"]];
        [filterButton setImage:[UIImage imageNamed:@"filter_icon"]];
        [_penButton setImage:[UIImage imageNamed:@"pentool_icon"]];
        [filterButton setTintColor: [UIColor whiteColor]];
        
        self.colorContainer.hidden=NO;
        self.filterCollectionView.hidden=YES;
        self.penColorView.hidden=YES;
        
    }else{
        isColor=NO;
        [button setImage:[UIImage imageNamed:@"brightness_tool"]];
        self.colorContainer.hidden=YES;
    }
}
//Multi Color Settings


- (IBAction)brightnessValue:(UISlider *)sender {
    
    cancelButton.enabled=YES;
    
    int choice=[eventChoice intValue];

    NSLog(@"%f",sender.value);
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",sender.value];

    UIImage *currentFilteredVideoFrame;
    
    switch (choice) {
        case editBrightness :
            @autoreleasepool {
                brightnessFilter.brightness = sender.value;
//                [brightnessFilter useNextFrameForImageCapture];
                finalFilter=brightnessFilter;
                [gpuImage processImage];
//                currentFilteredVideoFrame = [brightnessFilter imageFromCurrentFramebuffer];
                
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:BRIGHTNESS_VALUE];
            }
            break;
        case editContrast :
            @autoreleasepool {
                
                float contrastValue = 0.0;
                
                if (sender.value>1) {
                    contrastValue = pow(sender.value, (log(sender.value*2)/log(2)));
                    NSLog(@"power....%f",contrastValue);
                }else{
                    contrastValue=sender.value;
                }
                
                contrastFilter.contrast = contrastValue;
//               [contrastFilter useNextFrameForImageCapture];
                finalFilter=contrastFilter;
                [gpuImage processImage];
//                currentFilteredVideoFrame = [contrastFilter imageFromCurrentFramebuffer];
                
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:CONTRAST_VALUE];
            }
            break;
        case editHue :
            @autoreleasepool {
                
                float hueValue = 0.0;
                if (sender.value<0) {
                    hueValue=360.0f+sender.value;
                    NSLog(@".....%f",hueValue);
                    
                }else{
                    hueValue=sender.value;
                }
                hueFilter.hue = hueValue;
                finalFilter=hueFilter;
//                [hueFilter useNextFrameForImageCapture];
                [gpuImage processImage];
//                currentFilteredVideoFrame = [hueFilter imageFromCurrentFramebuffer];
                
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:HUE_VALUE];
            }
            break;
        case editSaturation :
            @autoreleasepool {
                
                saturationFilter.saturation = sender.value;
                finalFilter=saturationFilter;
//                [saturationFilter useNextFrameForImageCapture];
                [gpuImage processImage];
//                currentFilteredVideoFrame = [saturationFilter imageFromCurrentFramebuffer];
                
                [sliderValuesDict setValue:[NSNumber numberWithFloat:sender.value] forKey:SATURATION_VALUE];
            }
            break;
            
        default:
            break;
    }
    
//    snapImageView.image=currentFilteredVideoFrame;
    
}
-(void)sliderEnds:(id)sender
{
    NSLog(@"Bright slider released");
    if (!isEdited) {
        isEdited=YES;
    }
    
}


-(void)getEditedImage{
    if (isEdited) {
        if (final_image) {
            tempImage=final_image;
        }
        final_image=nil;
        isEdited=NO;
    }
}

- (IBAction)brightnessAction:(UIButton *)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editBrightness];
   
    [sender setSelected:YES];
    
    self.brightSlider.minimumValue = -0.3f;
    self.brightSlider.maximumValue = 0.3f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:BRIGHTNESS_VALUE] floatValue]);
    self.brightSlider.value=[[sliderValuesDict objectForKey:BRIGHTNESS_VALUE] floatValue];
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
    
    [_contrastButton setSelected:NO];
    [_hueButton setSelected:NO];
    [_saturationButton setSelected:NO];

}

- (IBAction)contrastAction:(UIButton *)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editContrast];
    [sender setSelected:YES];
    
    self.brightSlider.minimumValue = 0.5f;
    self.brightSlider.maximumValue = 2.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:CONTRAST_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:CONTRAST_VALUE] floatValue];
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
    
    [_saturationButton setSelected:NO];
    [_hueButton setSelected:NO];
    [_brightButton setSelected:NO];
    
}

- (IBAction)hueAction:(UIButton *)sender {
     [self getEditedImage];
    eventChoice=[NSNumber numberWithInt:editHue];
    [sender setSelected:YES];
    
    self.brightSlider.minimumValue = -30.0f;
    self.brightSlider.maximumValue = 30.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:HUE_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:HUE_VALUE] floatValue];
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
    
    [_contrastButton setSelected:NO];
    [_brightButton setSelected:NO];
    [_saturationButton setSelected:NO];
}

- (IBAction)saturationAction:(UIButton *)sender {
     [self getEditedImage];
    [sender setSelected:YES];
    
    eventChoice=[NSNumber numberWithInt:editSaturation];
    
    self.brightSlider.minimumValue = 0.0f;
    self.brightSlider.maximumValue = 2.0f;
    
    NSLog(@"%f",[[sliderValuesDict objectForKey:SATURATION_VALUE] floatValue]);
    
    self.brightSlider.value=[[sliderValuesDict objectForKey:SATURATION_VALUE] floatValue];
    
    self.sliderTestLabel.text=[NSString stringWithFormat:@"%f",_brightSlider.value];
    
    [_contrastButton setSelected:NO];
    [_hueButton setSelected:NO];
    [_brightButton setSelected:NO];

}

- (IBAction)deleteAction:(id)sender {
    if (isEdited) {
        isEdited=NO;
        
        UIAlertController *alert = [[UIAlertController alloc] init];
        //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"More" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *discardAction = [UIAlertAction actionWithTitle:@"Discard changes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.view endEditing:YES];
            
            [self cancellingEdit];
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:discardAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
//        [self cancellingEdit];
    }
}
-(void)doDoubleTap:(id)sender
{
    NSLog(@"Double tap resetting value");
    float resultValue=0.0f;
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

- (IBAction)penToolAction:(id)sender {
    self.filterCollectionView.hidden=YES;
    self.colorContainer.hidden=YES;
    if (isPen) {
        isPen=NO;
        self.penColorView.hidden=YES;
        self.drawLineView.userInteractionEnabled=NO;
//        self.undoButton.hidden=YES;
         [_penButton setImage:[UIImage imageNamed:@"pentool_icon"]];
    }else{
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PencilDraw" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(isDrawn:)
                                                     name:@"PencilDraw"
                                                   object:nil];
        
        isPen=YES;
        isFilter=NO;
        isColor=NO;
        self.drawLineView.userInteractionEnabled=YES;
        self.drawLineView.brushColor=[UIColor whiteColor];
        self.penColorView.hidden=NO;
//        self.undoButton.hidden=NO;
        [colorButton setImage:[UIImage imageNamed:@"brightness_tool"]];
        [filterButton setImage:[UIImage imageNamed:@"filter_icon"]];
        [_penButton setImage:[UIImage imageNamed:@"pentool_selected"]];
    }
}
-(void)isDrawn:(NSNotification *)notification{
    if ([notification.object isEqualToNumber:[NSNumber numberWithInt:0]]) {
        _undoButton.hidden=YES;
    }else{
        _undoButton.hidden=NO;
    }
}
- (IBAction)undoAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pentoolUndo"
     object:self];

}

#pragma mark UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.filterCollectionView) {
        return POLKA_FILTER;
    }else{
        return colorsArray.count;
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.filterCollectionView) {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
        
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:indexPath.row];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"After.png"]];
        
        
//        [(GPUImageRGBFilter *)filter setGreen:[(UISlider *)sender value]]
        
        [self.view addSubview:recipeImageView];
        return cell;
        
        
    }else{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor=[colorsArray objectAtIndex:indexPath.row];
    cell.contentView.layer.cornerRadius=10;
    cell .contentView.layer.masksToBounds=YES;
    return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.filterCollectionView) {
        
        NSInteger index = [indexPath row];
        
        /*
         RGB_FILTER,
         WHITE_BALANCE_FILTER,
         MONOCHROME_FILTER,
         AMATORKA_FILTER,
         ETIKA_FILTER,
         ELEGANCE_FILTER,
         INVERT_FILTER,
         THRESHOLD_FILTER,
         SOBEL_FILTER,
         TOON_FILTER,
         TILT_FILTER,
         POSTERIZE_FILTER,
         EMBOSS_FILTER,
         KUWAHARA_FILTER,
         CUSTOM_FILTER,
         UI_ELEMENT_FILTER,
         GRAYSCALE_FILTER,
         SEPIA_FILTER,
         SKETCH_FILTER,
         GAUSSIAN_FILTER,
         POLKA_FILTER
         */
        
        
        switch (index)
        {
            case RGB_FILTER:
                rgbfilter.green=0;
                rgbfilter.red=0;
                rgbfilter.blue=1;
                finalFilter=rgbfilter;
                [gpuImage processImage];

                break;
            case WHITE_BALANCE_FILTER:
                
                rgbfilter.green=1;
                rgbfilter.red=0;
                rgbfilter.blue=1;
                finalFilter=rgbfilter;
                [gpuImage processImage];
                
                break;
            case MONOCHROME_FILTER:
                rgbfilter.green=2;
                rgbfilter.red=0;
                rgbfilter.blue=2;
                finalFilter=rgbfilter;
                [gpuImage processImage];
                break;
            case AMATORKA_FILTER:
                whilteFilter.temperature=1000;
                whilteFilter.tint=2.0;
                finalFilter=whilteFilter;
                [gpuImage processImage];
                break;
            case ETIKA_FILTER:
                whilteFilter.temperature=2000;
                finalFilter=whilteFilter;
                [gpuImage processImage];
                break;
            case ELEGANCE_FILTER:
                whilteFilter.temperature=3000;
                finalFilter=whilteFilter;
                [gpuImage processImage];
                break;
            case INVERT_FILTER:
                whilteFilter.temperature=4000;
                finalFilter=whilteFilter;
                [gpuImage processImage];
                break;
            case THRESHOLD_FILTER:
                break;
            case SOBEL_FILTER:
                break;
            case TOON_FILTER:
                break;
            case TILT_FILTER:
                break;
            case POSTERIZE_FILTER:
                break;
            case EMBOSS_FILTER:
                break;
            case KUWAHARA_FILTER:
                break;
            case CUSTOM_FILTER:
                break;
            case UI_ELEMENT_FILTER:
                break;
            case GRAYSCALE_FILTER:
                break;
            case SEPIA_FILTER:
                break;
            case SKETCH_FILTER:
                break;
            case GAUSSIAN_FILTER:
                break;
            case POLKA_FILTER:
                break;
                
        }
        
    }else{
        UICollectionViewCell *selectedCell=[collectionView cellForItemAtIndexPath:indexPath];
        self.drawLineView.brushColor=[colorsArray objectAtIndex:indexPath.row];
        if (prevCell) {
            prevCell.layer.borderColor=[UIColor clearColor].CGColor;
            prevCell.layer.masksToBounds=YES;
        }
        selectedCell.layer.borderColor=[UIColor blackColor].CGColor;
        selectedCell.layer.borderWidth=2.0f;
        selectedCell.layer.masksToBounds=YES;
        prevCell=selectedCell;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.filterCollectionView) {
        return CGSizeMake(100, 100);
    }
    return CGSizeMake(20, 20);
}


@end
