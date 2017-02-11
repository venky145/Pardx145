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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileInfo:) name:PROFILE_UPDATE object:nil];
    
    [self updateProfileInfo:nil];
    
    self.iconImage.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.iconImage addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
    
    
    
     NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
    
    int notifType=[Context contextSharedManager].pushType;
    
    if (notifType!=0) {
        
        [self pushNotificationReceived:notifType];
    }
}
-(void)pushNotificationReceived:(int)notify{
    
    if(notify!=0){        
        switch (notify) {
            case new_Challenge:
                
                [self acceptAction:nil];
                
                break;
            case complete_Challenge:
                
                [self completeAction:nil];
                
                break;
            case friend_Request:
                
                [self.tabBarController setSelectedIndex:2];
                
                break;
            case friend_Accept:
                
                [self.tabBarController setSelectedIndex:2];

                break;
                
            default:
                break;
        }
        
        [[Context contextSharedManager] setPushType:0];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;    
}
-(void)viewDidAppear:(BOOL)animated
{
   
}
-(void)updateProfileInfo:(id)sender
{
    
    userProfile=[User_Profile fetchDetailsFromDatabase:@"User_Profile"];
    
//    UIImage *myImage;
    
    if (userProfile.firstname.length>0) {
        if (userProfile.lastname.length>0) {
            userNameLabel.text=[NSString stringWithFormat:@"%@ %@",userProfile.firstname,userProfile.lastname];
        }
        else
            userNameLabel.text=[NSString stringWithFormat:@"%@",userProfile.firstname];
        
    }else
    {
        userNameLabel.text=userProfile.username;
    }

//    if (userProfile.profilePicture.length>0) {
//        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:userProfile.profilePicture];
//        myImage = [UIImage imageWithData:imageData];
//    }else{
//        myImage=[UIImage imageNamed:@"UserMale.png"];
//    }
//    self.iconImage.image=myImage;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:userProfile.profilePicture] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    self.scoreLabel.text=[NSString stringWithFormat:@"%@",userProfile.score];
    if (userProfile.about.length>0) {
        self.aboutLabel.text=userProfile.about;
    }else{
       self.aboutLabel.text=@"No Description";
    }
    
    
     [[Context contextSharedManager] roundImageView:self.iconImage];
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
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CompletedViewController *completeView = [storyBoard instantiateViewControllerWithIdentifier:@"completed"];
    [self presentViewController:completeView animated:NO completion:nil];
   
}

- (IBAction)acceptAction:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AcceptViewController *acceptView = [storyBoard instantiateViewControllerWithIdentifier:@"accepted"];
    [self presentViewController:acceptView animated:NO completion:nil];
}

- (IBAction)newAction:(id)sender
{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CamOverlayViewController *overlayView = [storyBoard instantiateViewControllerWithIdentifier:@"CamOverlayViewController"];
    
    [self presentViewController:overlayView animated:NO completion:nil];
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
     AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
