//
//  ProfileImageController.m
//  Parodize
//
//  Created by Apple on 13/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "ProfileImageController.h"

@interface ProfileImageController ()

@end

@implementation ProfileImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.profileImageView setImage:_profileData];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    }];
    
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

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
