//
//  PendingCell.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mockImage;

@property (strong, nonatomic) IBOutlet UIButton *notifyButton;


@end
