//
//  CompletedCell.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *textDesc;

@property (strong, nonatomic) IBOutlet UIImageView *mockImage;
@property (strong, nonatomic) IBOutlet UILabel *messagelabel;
@end
