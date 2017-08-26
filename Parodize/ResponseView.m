//
//  ResponseView.m
//  Parodize
//
//  Created by Apple on 19/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "ResponseView.h"

@implementation ResponseView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius=5.0f;
    self.layer.cornerRadius=5.0f;
    self.layer.masksToBounds=YES;
//    self.layer.borderColor=[[Context contextSharedManager]colorWithRGBHex:PROFILE_COLOR].CGColor;
//    self.layer.borderWidth=1.0f;
}


- (IBAction)likeAction:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected=YES;
    }else{
        sender.selected=NO;
    }
}
@end
