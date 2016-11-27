//
//  SignUpPageViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpPageViewController : ActivityBaseViewController <UITableViewDataSource,UITableViewDelegate,DataManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *textDict;

@property (weak, nonatomic) IBOutlet UITableView *signupTableView;

- (IBAction)signupAction:(id)sender;

- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;


@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end
