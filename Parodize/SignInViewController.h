//
//  SignInViewController.h
//  Parodize
//
//  Created by Apple on 03/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SignInViewController : ActivityBaseViewController<NSURLSessionDelegate,NSURLConnectionDelegate,DataManagerDelegate,UITextFieldDelegate>

@property (nonatomic) AppDelegate *appDelegate;

- (IBAction)cancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *passForgotButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)signupAction:(id)sender;

- (IBAction)signInAction:(id)sender;

- (IBAction)forgotPassAction:(id)sender;


@end
