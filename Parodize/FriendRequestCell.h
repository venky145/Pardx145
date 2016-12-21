//
//  FriendRequestCell.h
//  Parodize
//
//  Created by Apple on 15/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end
