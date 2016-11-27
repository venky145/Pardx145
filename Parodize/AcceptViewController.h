//
//  AcceptViewController.h
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptViewController : ActivityBaseViewController<DataManagerDelegate>

- (IBAction)backAction:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *acceptTableView;

@property (nonatomic,strong) NSMutableArray *challenges;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
