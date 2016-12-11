//
//  FirstViewController.m
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CamOverlayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ImageEditingViewController.h"
#import "AppDelegate.h"
#import "SplashViewController.h"
#import "SWRevealViewController.h"
#import "CompletedViewController.h"
#import "AcceptViewController.h"
#import "User_Profile.h"


@interface HomeViewController ()
{
    UIImage  *mockImage;
    
    AppDelegate *appDelegate;
    
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *recentImage;
@end

@implementation HomeViewController

@synthesize iconImage,completeButton,buttonNew,acceptButton,optionView,userNameLabel;

@synthesize userProfile,pr_Image;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileInfo:) name:@"ProfileUpdated" object:nil];
    
    [self updateProfileInfo:nil];
    
    self.iconImage.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.iconImage addGestureRecognizer:singleTap];
    
    
    
     NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[Context contextSharedManager] roundImageView:self.iconImage];
}
-(void)updateProfileInfo:(id)sender
{
//    if ([sender isKindOfClass:[NSNotification class]])   {
//        
//        NSNotification *noitifyInfo=(NSNotification *)sender;
//        
//        userProfile=noitifyInfo.object;
//    }
    
    userProfile=[User_Profile fetchDetailsFromDatabase:@"User_Profile"];
    
    UIImage *myImage;
    
    if (userProfile.firstname.length>0) {
        if (userProfile.lastname.length>0) {
            userNameLabel.text=[NSString stringWithFormat:@"%@ %@",userProfile.firstname,userProfile.lastname];
        }
        else
            userNameLabel.text=[NSString stringWithFormat:@"%@",userProfile.firstname];
        
    }else
    {
        userNameLabel.text=userProfile.email;
    }
    
    
    
    if (userProfile.profilePicture.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:userProfile.profilePicture];
        myImage = [UIImage imageWithData:imageData];
    }else{
        myImage=[UIImage imageNamed:@"UserMale.png"];
    }
    
    self.iconImage.image=myImage;
}
-(void)profileImageTouched:(id)sender
{
    [self.tabBarController setSelectedIndex:2];
}


-(void)setUpLayerForButton:(UIButton *)button
{
    button.layer.cornerRadius=10.0f;
    // 66CC99
    button.layer.borderColor=[self colorWithHexString:@"66CC99"].CGColor;
    button.layer.borderWidth=2.0f;
    button.layer.masksToBounds=YES;
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


- (IBAction)completeAction:(id)sender {
    
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/me"
//                                  parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        // Handle the result
//    }];
    
   /* UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CompletedViewController *completeView = [storyBoard instantiateViewControllerWithIdentifier:@"completed"];
   // completeView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:completeView animated:YES];
    */
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CompletedViewController *completeView = [storyBoard instantiateViewControllerWithIdentifier:@"completed"];
    // tabView.hidesBottomBarWhenPushed = YES;
    //tabView.snapImage=getImage;
    [self presentViewController:completeView animated:NO completion:nil];
   
}

- (IBAction)acceptAction:(id)sender {
    
    
  /*  UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AcceptViewController *acceptView = [storyBoard instantiateViewControllerWithIdentifier:@"accepted"];
    [self.navigationController pushViewController:acceptView animated:YES];
   */
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AcceptViewController *acceptView = [storyBoard instantiateViewControllerWithIdentifier:@"accepted"];
   // tabView.hidesBottomBarWhenPushed = YES;
    //tabView.snapImage=getImage;
    [self presentViewController:acceptView animated:NO completion:nil];
}

- (IBAction)newAction:(id)sender
{
    //[self performSegueWithIdentifier:@"EditPhoto" sender:self];
    
   // [self performSegueWithIdentifier:@"EditPhoto" sender:self];
//    ImageEditingViewController *myController = [[ImageEditingViewController alloc]init];
//    myController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myController animated:YES];

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

- (IBAction)logoutAction:(id)sender
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SplashViewController  *splachViewController= [storyBoard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    
    for (int i = 0 ; i <viewControlles.count; i++){
        if ([splachViewController isKindOfClass:[viewControlles objectAtIndex:i]]) {
            //Execute your code
            
            [[self navigationController] popToViewController:splachViewController animated:YES];
            
            return;
        }
    }
     AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    appDelegateTemp.window.rootViewController = splachViewController;
    
    [self.revealViewController.view removeFromSuperview];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[FBSDKLoginManager new] logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else
    {
        
    }
    

    
   // [self.revealViewController dismissViewControllerAnimated:YES completion:nil];
    
//    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
//   UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//
//    SplashViewController  *splachViewController= [storyBoard instantiateViewControllerWithIdentifier:@"SplashViewController"];
//    appDelegateTemp.window.rootViewController = splachViewController;
//    
//    [[self navigationController] popToViewController:splachViewController animated:YES];
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

    NSLog(@"Done");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   // [self performSegueWithIdentifier:@"EditPhoto" sender:self];
    
    mockImage=info[UIImagePickerControllerOriginalImage];
    
     appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.getNewImage=mockImage;
    
//    UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);
//    UIImageWriteToSavedPhotosAlbum(getImage,
//                                   self, // send the message to 'self' when calling the callback
//                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
//                                   NULL); // you generally won't need a contextInfo here
    
//    [self dismissViewControllerAnimated:NO completion:^{
    
    if (imagePicker) {
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        imagePicker=nil;
    }
    
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ImageEditingViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"editPhoto"];
        //tabView.hidesBottomBarWhenPushed = YES;
        
        [self.picker presentViewController:tabView animated:YES completion:nil];
    
        
       // [self performSegueWithIdentifier:@"editPhoto" sender:self];

 //   }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editPhoto"]) {
        //[self.picker dismissViewControllerAnimated:NO completion:nil];

        ImageEditingViewController *imageViewController = segue.destinationViewController;
        imageViewController.getImage = mockImage;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}
//- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
//    if (error) {
//        // Do anything needed to handle the error or display it to the user
//    } else {
//        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        ImageEditingViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"editPhoto"];
//        tabView.hidesBottomBarWhenPushed = YES;
//        //tabView.snapImage=getImage;
//        [self.picker presentViewController:tabView animated:YES completion:nil];
//    }
//}
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
@end
