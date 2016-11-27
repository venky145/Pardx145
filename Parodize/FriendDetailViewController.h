//
//  FreindDetailViewController.h
//  Parodize
//
//  Created by Apple on 11/11/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsObject.h"

@interface FriendDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *challengeView;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) FriendsObject *friendObj;
- (IBAction)followAction:(id)sender;
- (IBAction)challengeAction:(id)sender;
- (IBAction)addFriendAction:(id)sender;

@end
