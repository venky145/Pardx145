//
//  SlideView.h
//  Parodize
//
//  Created by Apple on 27/03/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideView : UIView

@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UIImageView *slideProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *slideContentImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
