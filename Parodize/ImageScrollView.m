//
//  ImageScrollView.m
//  Parodize
//
//  Created by Apple on 19/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    self.scaleImageView = [[UIImageView alloc] init];
    self.scaleImageView.frame=self.bounds;
    
    scrollView.contentSize = self.scaleImageView.bounds.size;
    [scrollView addSubview:self.scaleImageView];
    
    float minScale  = scrollView.frame.size.width  / self.scaleImageView.frame.size.width;
    scrollView.minimumZoomScale = minScale;
    scrollView.maximumZoomScale = 10.0;
    scrollView.zoomScale = minScale;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleImageView;
}

@end
