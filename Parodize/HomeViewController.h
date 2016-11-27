//
//  FirstViewController.h
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "User_Profile.h"

@interface HomeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,DataManagerDelegate>

@property (nonatomic,retain) User_Profile *userProfile;

@property (nonatomic,strong) UIImage *pr_Image;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonNew;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic,retain) UIImagePickerController *picker;

- (IBAction)completeAction:(id)sender;

- (IBAction)acceptAction:(id)sender;

- (IBAction)newAction:(id)sender;

- (IBAction)logoutAction:(id)sender;



@end

