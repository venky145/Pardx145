//
//  SplashViewController.h
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"


#import "DataManager.h"

@interface SplashViewController : ActivityBaseViewController<NSURLSessionDelegate,NSURLConnectionDelegate,DataManagerDelegate>

@property (nonatomic) AppDelegate *appDelegate;

- (IBAction)tabAction:(id)sender;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twtrButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

- (IBAction)emailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageTestView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *passForgotButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)closeSignInAction:(id)sender;

- (IBAction)signupAction:(id)sender;

- (IBAction)signInAction:(id)sender;

- (IBAction)forgotPassAction:(id)sender;

- (IBAction)loginFaceBookAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicatorView;

@property (weak, nonatomic) IBOutlet UILabel *loginName;


@end
