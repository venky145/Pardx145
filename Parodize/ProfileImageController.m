//
//  ProfileImageController.m
//  Parodize
//
//  Created by Apple on 13/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "ProfileImageController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileImageController ()

@end

@implementation ProfileImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.profileImageView setImage:_profileData];
    
    [UIView animateWithDuration:5.0f animations:^{
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    }];
    
//    self.scrollView.minimumZoomScale = 0.5;
//    self.scrollView.maximumZoomScale = 6.0;
//    self.scrollView.contentSize = self.profileImageView.frame.size;
//    self.scrollView.delegate = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.profileImageView;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
