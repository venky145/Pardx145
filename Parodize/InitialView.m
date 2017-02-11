//
//  InitialView.m
//  Parodize
//
//  Created by Apple on 04/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "InitialView.h"

@implementation InitialView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect upperRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    CGRect lowerRect = CGRectMake(rect.origin.x, rect.size.height /2, rect.size.width, rect.size.height /2);
    
    [[[Context contextSharedManager] colorWithRGBHex:UPPER_COLOR] set];
    UIRectFill(upperRect);
    [[[Context contextSharedManager] colorWithRGBHex:LOWER_COLOR] set];
    UIRectFill(lowerRect);
}


@end
