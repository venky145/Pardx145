//
//  ProfileViewController.h
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Profile.h"
#import "iCarousel.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ActivityBaseViewController.h"

@interface ProfileViewController : ActivityBaseViewController<UITableViewDataSource,UITableViewDelegate,FBSDKSharingDelegate>


@property (nonatomic,strong) User_Profile *userProfile;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileSubName;

- (IBAction)editProfileAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *pendingView;

@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (weak, nonatomic) IBOutlet UICollectionView *pendingCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *completedCollection;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downButton;
- (IBAction)downAction:(UIBarButtonItem *)sender;

//@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet iCarousel *pendingCarousel;
@property (weak, nonatomic) IBOutlet iCarousel *completedCarousel;

@end
