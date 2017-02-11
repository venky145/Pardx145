//
//  ProfileViewController.h
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Profile.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) User_Profile *userProfile;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileSubName;

@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
- (IBAction)followAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
- (IBAction)editProfileAction:(id)sender;

- (IBAction)logoutAction:(id)sender;

//@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
