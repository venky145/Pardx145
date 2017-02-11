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

@interface SplashViewController : ActivityBaseViewController<NSURLSessionDelegate,NSURLConnectionDelegate,DataManagerDelegate,UITextFieldDelegate>

@property (nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twtrButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
- (IBAction)emailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageTestView;
@property (weak, nonatomic) IBOutlet UIView *loginView;


- (IBAction)loginFaceBookAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicatorView;

@property (weak, nonatomic) IBOutlet UILabel *loginName;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
