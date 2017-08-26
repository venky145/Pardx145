//
//  PlayGroundCollectionViewCell.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/03/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "PlayGroundCollectionViewCell.h"

@implementation PlayGroundCollectionViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius=5.0f;
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:0.5f];
    
    self.countLabel.layer.cornerRadius=self.countLabel.frame.size.width/2;
    self.countLabel.layer.masksToBounds=YES;
    [self.countLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.countLabel.layer setBorderWidth:0.5f];
    
    CALayer *shadowLayer = [CALayer new];
    shadowLayer.frame = CGRectMake(0,0,20,20);
    shadowLayer.cornerRadius = 10;
    
    shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 0.6;
    shadowLayer.shadowOffset = CGSizeMake(0,2);
    shadowLayer.shadowRadius = 3;
    [shadowLayer addSublayer:self.countLabel.layer];
    
    [self.layer addSublayer:shadowLayer];

}
@end
