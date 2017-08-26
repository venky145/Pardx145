//
//  VerticalScrollView.h
//  Parodize
//
//  Created by Apple on 04/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VerticalScrollView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView* originalImage;
@property (nonatomic,retain) UIImageView* mockImage;
@property (nonatomic,retain) UILabel* originalCaption;
@property (nonatomic,retain) UILabel* mockCaption;
@property (nonatomic,retain) UIView* saperator;
@property (nonatomic,retain) UISwitch *visibleSwitch;
@property (assign) BOOL isPending;

@end
