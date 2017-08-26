//
//  FreindDetailViewController.h
//  Parodize
//
//  Created by Apple on 11/11/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsObject.h"

@interface FriendDetailViewController : ActivityBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;


@property (weak, nonatomic) FriendsObject *friendObj;

- (IBAction)followAction:(id)sender;
- (IBAction)challengeAction:(id)sender;
- (IBAction)addFriendAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UICollectionView *challengeCollection;

@property (weak, nonatomic) IBOutlet UILabel *noLabel;


@end
