//
//  SlideView.m
//  Parodize
//
//  Created by Apple on 27/03/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "SlideView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.slideView.layer.cornerRadius=5.0f;
    self.slideProfileImage.layer.cornerRadius=self.slideProfileImage.frame.size.height/2;
    self.slideView.clipsToBounds=YES;
    self.slideView.layer.borderColor=[[Context contextSharedManager]colorWithRGBHex:PROFILE_COLOR].CGColor;
    self.slideView.layer.borderWidth=1.0f;
}


@end
