//
//  CamOverlayViewController.m
//  Parodize
//
//  Created by administrator on 17/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "CamOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface CamOverlayViewController (){
    
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *recentImage;
@end

@implementation CamOverlayViewController

@synthesize cameraButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    cameraButton.layer.cornerRadius=cameraButton.frame.size.height/2;
//    cameraButton.layer.borderWidth=2.0f;
//    cameraButton.layer.borderColor=[UIColor whiteColor].CGColor;
//    cameraButton.layer.masksToBounds=YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self cameraScreen];
    
}
-(void)cameraScreen{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.picker.showsCameraControls = NO;
        self.picker.navigationBarHidden = YES;
        self.picker.toolbarHidden = YES;
        self.picker.delegate=self;
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0); //This slots the preview exactly in the middle of the screen by moving it down 71 points
        self.picker.cameraViewTransform = translate;
        
        CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
        self.picker.cameraViewTransform = scale;
        
        self.snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
        self.snapButton.clipsToBounds = YES;
        self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
        self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.snapButton.layer.borderWidth = 2.0f;
        self.snapButton.backgroundColor = [self colorWithHexString:@"33B5A1"];
        self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.snapButton.layer.shouldRasterize = YES;
        
        CGPoint centerFrame=self.view.center;
        
        centerFrame.y=screenHeight-90;
        centerFrame.x-=35;
        
        CGRect rect={centerFrame,self.snapButton.frame.size};
        
        self.snapButton.frame=rect;
        [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.picker.view addSubview:self.snapButton];
        
        self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashButton.frame = CGRectMake(16, 20, 40, 40);
        [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-off.png"] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-on.png"] forState:UIControlStateSelected| UIControlStateHighlighted];
        self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.flashButton.hidden=YES;
        [self.picker.view addSubview:self.flashButton];
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchButton.frame = CGRectMake(screenWidth-60, 20, 50,50);
        [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.picker.view addSubview:self.switchButton];
        
        self.recentImage = [[UIImageView alloc]init];
        self.recentImage.frame = CGRectMake(16, self.snapButton.frame.origin.y, 70, 70);
        self.recentImage.backgroundColor=[UIColor clearColor];
        [self.recentImage setContentMode:UIViewContentModeScaleToFill];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhotoLibrary:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        [self.recentImage addGestureRecognizer:singleTap];
        
        self.recentImage.clipsToBounds = YES;
        self.recentImage.layer.cornerRadius = self.recentImage.frame.size.width / 2.0f;
        self.recentImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.recentImage.layer.borderWidth = 2.0f;
        self.recentImage.userInteractionEnabled = YES; //disabled by default
        
        
        [self.picker.view addSubview:self.recentImage];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(screenWidth-90, self.snapButton.frame.origin.y, 70, 70);
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelCamera:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.clipsToBounds = YES;
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.width / 2.0f;
        self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.cancelButton.layer.borderWidth = 2.0f;
        
        [self.picker.view addSubview:self.cancelButton];
        
        
        
        
        
        
        // self.picker.wantsFullScreenLayout = YES;
        
        //    // Insert the overlay
        //    self.overlay = [[OverlayViewController alloc] initWithNibName:@"Overlay" bundle:nil];
        //    self.overlay.pickerReference = self.picker;
        //    self.picker.cameraOverlayView = self.overlay.view;
        //    self.picker.delegate = self.overlay;
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        PHAsset *lastAsset = [fetchResult lastObject];
        [[PHImageManager defaultManager] requestImageForAsset:lastAsset
                                                   targetSize:self.recentImage.bounds.size
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:PHImageRequestOptionsVersionCurrent
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [[self recentImage] setImage:result];
                                                        
                                                    });
                                                }];
        
        
        [self presentViewController:self.picker animated:NO completion:nil];
        
//        [self.view addSubview:self.picker];
    }
    else
    {
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera not found" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Camera Not Found" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)openPhotoLibrary:(UITapGestureRecognizer *)gesture
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.translucent = false;
    imagePicker.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.picker presentViewController:imagePicker animated:YES completion:nil];
}
-(void)cancelCamera:(id)sender
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)snapButtonPressed:(id)sender
{
    [self.picker takePicture];
    
    
    //[self performSegueWithIdentifier:@"addToCartSegue" sender:self];
}
-(void)flashButtonPressed:(id)sender
{
    if (self.picker.cameraFlashMode ==
        UIImagePickerControllerCameraFlashModeOff) {
        
        if ([UIImagePickerController
             isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear ])
            
        {
            
            [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-on.png"] forState:UIControlStateNormal];
            
            self.picker.cameraFlashMode =
            UIImagePickerControllerCameraFlashModeOn;
        }
    }
    else
    {
        self.picker.cameraFlashMode =
        UIImagePickerControllerCameraFlashModeOff;
        
        [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-off.png"] forState:UIControlStateNormal];
    }
}
-(void)switchButtonPressed:(id)sender
{
    self.picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    if (self.picker.cameraDevice==UIImagePickerControllerCameraDeviceFront)
    {
        self.flashButton.hidden=NO;
        
        
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else if (self.picker.cameraDevice==UIImagePickerControllerCameraDeviceRear)
    {
        self.flashButton.hidden=YES;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"imageDone");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Done");
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)snapShotAction:(id)sender {
    
    [imagePicker takePicture];
    
}

- (IBAction)camRotate:(id)sender {
}

- (IBAction)camFlash:(id)sender {
}
@end
