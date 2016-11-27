//
//  SignUpViewController.h
//  Parodize
//
//  Created by administrator on 25/10/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameText;

@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)signUpAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (IBAction)cameraAction:(id)sender;
@end
