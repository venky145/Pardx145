//
//  SecondViewController.m
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "PlayGroudViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PGDetailViewController.h"
#import "PlayGroundCollectionViewCell.h"



@interface PlayGroudViewController ()
{
 //   SWRevealViewController *revealViewController;
}

@end

@implementation PlayGroudViewController

@synthesize distanceButton,challengeButton,collectionView,profileImage,messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  //  collectionView.hidden=YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(DistanceValueChanged:) name:@"NotificationMessageEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(tabBarStatus:) name:@"NotificationRevealedEvent" object:nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.panGestureRecognizer.enabled=YES;
    if ( revealViewController )
    {
        [distanceButton addTarget:self action: @selector( revealToggleBtn: ) forControlEvents:UIControlEventTouchUpInside];
       // [distanceButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
   // [distanceButton addTarget:self action: @selector(revealToggleBtn:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    
    NSLog(@"%@ .... %@",self,self.view);

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
-(void)viewWillAppear:(BOOL)animated
{
    profileImage.layer.borderWidth=2.0f;
    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
    [profileImage.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profileImage.layer setShadowColor:[UIColor blackColor].CGColor];
    [profileImage.layer setShadowOpacity:0.8];
    [profileImage.layer setShadowRadius:3.0];
    [profileImage.layer setShadowOffset:CGSizeMake(1.0, 5.0)];
    profileImage.layer.masksToBounds=YES;
    
}
-(void)revealToggleBtn:(id)sender
{
//    UIButton *myButton=(UIButton *)sender;
//    
//    if (myButton.selected)
//    {
//        [myButton setSelected:NO];
//        //[self showTabBar:self.tabBarController];
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//    }
//    else
//    {
//        [myButton setSelected:YES];
//        //[self hideTabBar:self.tabBarController];
//        self.tabBarController.tabBar.userInteractionEnabled = NO;
//
//    }
    
    [self.revealViewController revealToggle:nil];
}
-(void)tabBarStatus:(NSNotification *)notification
{
    NSLog(@"%@",notification.object);
    
    if (notification.object==(id)kCFBooleanTrue)
    {
        NSLog(@"Revealed");
         self.tabBarController.tabBar.userInteractionEnabled = NO;
    }
    else if(notification.object==(id)kCFBooleanFalse)
    {
        NSLog(@"Closed");
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}
/*
- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:self.view.bounds];
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"s....%@",view);
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"se....%@",view);
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        
    }];
}
- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:self.view.bounds];
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"h....%@",view);
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"he.....%@",view);
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
        
    }];
}
*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_c cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *identifier = @"CellGrid";
    
    PlayGroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayGroundCollectionViewCell" forIndexPath:indexPath];
    
  //  UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
   // recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
    
    [cell.pgImageView setImage:[UIImage imageNamed:@"Icon@2x.png"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; //the spacing between cells is 2 px here
}
-(void)DistanceValueChanged:(NSNotification *)notification
{
    UISlider *slider=(UISlider *) notification.object;
    
    NSLog(@"%d",10-(int)roundf(slider.value));
    
    int distanceValue=10-(int)roundf(slider.value);
    
    [distanceButton setTitle:[NSString stringWithFormat:@"%d miles",distanceValue] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)challengeAction:(id)sender
{
    
    [self performSegueWithIdentifier:@"PGDetail" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PGDetail"]) {
        
        PGDetailViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed=YES;
}
}
- (IBAction)upScrollAction:(id)sender {
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}
- (IBAction)downScrollAction:(id)sender {
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

@end
