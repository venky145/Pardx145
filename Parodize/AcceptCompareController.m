//
//  AcceptCompareController.m
//  Parodize
//
//  Created by Apple on 21/01/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "AcceptCompareController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageEditingViewController.h"

@interface AcceptCompareController ()

@end

@implementation AcceptCompareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.originalImage.image=appDelegate.getNewImage;
    
    NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:appDelegate.acceptImage];
    self.mockImage.image= [UIImage imageWithData:imageData];
    
    [[Context contextSharedManager] drawBorder:self.originalImage];
    [[Context contextSharedManager] drawBorder:self.mockImage];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
    
    self.navigationItem.rightBarButtonItem=barButton;
    
    
}
-(void)doneAction:(id)sender{
    
    [self performSegueWithIdentifier:@"acceptEdit" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([segue.identifier isEqualToString:@"acceptEdit"]) {
    
    //        AcceptSendViewController *destViewController = segue.destinationViewController;
    //        destViewController.getImage = stillImage;
    //        destViewController.acceptID = self.getId;
    //        destViewController.getMockImage=self.acceptImageView.image;
    //        destViewController.isAccept = YES;
    
            ImageEditingViewController *tabView = segue.destinationViewController;
            tabView.isAccept=YES;
    
        }
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
