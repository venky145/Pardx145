//
//  TWActivityBaseViewController.m
//  Titan Watch
//
//  Created by VenkateshX Mandapati on 10/30/15.
//  Copyright © 2015 VenkateshX Mandapati. All rights reserved.
//

#import "ActivityBaseViewController.h"
#import "PRActivityIndicator.h"
#import "AppDelegate.h"


@interface ActivityBaseViewController ()

@property (strong, nonatomic) PRActivityIndicator *activityView;

@end

@implementation ActivityBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityView = [PRActivityIndicator createTGCActivityIndicator];
    [_activityView.activityIndicator startAnimating];


}

- (void) showActivityWithMessage:(NSString *) message
{
    [self showActivityInView:nil withMessage:message];
}

-(void)showActivityOnPrsentModule
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.activityView.frame = frame;
    
    [self.view addSubview:self.activityView];
}

- (void) showActivityInView:(UIView *) view withMessage:(NSString *) message
{
    if (view)
    {
        self.activityView.frame = view.bounds;
    }
    else
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.activityView.frame = frame;
    }
    
    if (view == nil)
    {
        AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appdelegate.window.rootViewController.view addSubview:self.activityView];
    }
    else
    {
        [view addSubview:self.activityView];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [_activityView.activityIndicator startAnimating];
    _activityView.activityMessageLbl.text = message;
}

- (void) hideActivity
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [_activityView.activityIndicator stopAnimating];
    [_activityView removeFromSuperview];
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
