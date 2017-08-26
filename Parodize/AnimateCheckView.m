//
//  AnimateCheckView.m
//  Parodize
//
//  Created by Apple on 26/08/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "AnimateCheckView.h"

@implementation AnimateCheckView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIImageView *checkImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 0, 0)];
    [checkImage setImage:[UIImage imageNamed:@"sendChecked"]];
    checkImage.layer.cornerRadius = checkImage.frame.size.height/2;
    [self addSubview:checkImage];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        checkImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            checkImage.frame = CGRectMake(25, 25, 0, 0);
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkAnimation" object:nil];
        }];
    }];
}


@end
