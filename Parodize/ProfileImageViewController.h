//
//  ProfileImageViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileImageViewController : ActivityBaseViewController

@property (assign) BOOL isFacebookRegister;

@property (weak, nonatomic) IBOutlet UITextField *usernameText;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)checkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
- (IBAction)doneAction:(id)sender;

@end
