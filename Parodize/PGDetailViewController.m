//
//  PGDetailViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 19/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "PGDetailViewController.h"
#import "UIImage+ImageEffects.h"

@interface PGDetailViewController ()
{
    UIImageView *blurredBgImage;
}
@end

@implementation PGDetailViewController

@synthesize topView,bottomView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //[topView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.7]];
    
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
//        
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.view.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
//        [bottomView addSubview:blurEffectView];
//    }
//    else {
//        self.view.backgroundColor = [UIColor blackColor];
//    }
    
  //  topView.backgroundColor =
   // UIColor.clearColor().colorWithAlphaComponent(0.7)
    
    blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:bottomView]];
    
   // topView.backgroundColor = [UIColor whiteColor];
    
    blurredBgImage.layer.mask = bottomView.layer;
    
}
- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}
- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    CGFloat reductionFactor = 1;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
