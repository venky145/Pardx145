//
//  AcceptCustomCell.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 07/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPic;
@property (strong, nonatomic) IBOutlet UILabel *challengeLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mockImage;

@end
