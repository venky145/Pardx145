//
//  PlayGroundCollectionViewCell.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/03/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayGroundCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pgImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end
