//
//  DistanceViewController.m
//  Parodize
//
//  Created by administrator on 22/10/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "DistanceViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DistanceViewController ()
{
    UILabel *yourLabel;
}
@end

@implementation DistanceViewController
@synthesize dragSlider,distanceLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    yourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    
    
    dragSlider=[[UISlider alloc]initWithFrame:CGRectMake(50, 0, 350, 350)];
    
    dragSlider.minimumValue=0;
    dragSlider.maximumValue=10;
    dragSlider.value=10;
    
    [dragSlider setMaximumTrackTintColor:[UIColor blueColor]];
    [dragSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
    
    [dragSlider.layer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    dragSlider.transform = CGAffineTransformMakeRotation(M_PI/2);
    yourLabel.transform=CGAffineTransformMakeRotation(- M_PI/2);
    
    [dragSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [dragSlider addTarget:self
                  action:@selector(sliderDidEndSliding:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [dragSlider setThumbImage:[UIImage imageNamed:@"Drag_Marker.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:dragSlider];
    
    [self.view addSubview:yourLabel];
    
    NSLog(@"%f",dragSlider.frame.origin.y);

}
-(void)sliderDidEndSliding:(UISlider *)slider
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object:slider];
}
-(void)sliderValueChanged:(UISlider *)mapSlider
{
   // NSLog(@"%f",mapSlider.value);
    CGRect trackRect = [mapSlider trackRectForBounds:mapSlider.bounds];
    CGRect thumbRect = [mapSlider thumbRectForBounds:mapSlider.bounds
                                             trackRect:trackRect
                                                 value:mapSlider.value];
    
    yourLabel.center = CGPointMake(thumbRect.origin.x + mapSlider.frame.origin.x,  mapSlider.frame.origin.y - 20);

    int value=10-(int)roundf(mapSlider.value);
    
    distanceLabel.text= [NSString stringWithFormat:@"%d miles",value];
    
    CGPoint point=CGPointMake(0,mapSlider.value + dragSlider.frame.origin.y);
    
    yourLabel.frame=CGRectMake(point.x, point.y, 50, 20);
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Disappear %hhd",animated);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationRevealedEvent" object:(id)kCFBooleanTrue];
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"Dissapear %hhd",animated);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationRevealedEvent" object:(id)kCFBooleanFalse];
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
