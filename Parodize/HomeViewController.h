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
#import "iCarousel.h"

@interface HomeViewController : ActivityBaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,DataManagerDelegate,iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,retain) User_Profile *userProfile;

@property (nonatomic,strong) UIImage *pr_Image;

@property (nonatomic,strong) NSMutableArray *challenges;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
@property (weak, nonatomic) IBOutlet UILabel *ignoreLabel;


@end

