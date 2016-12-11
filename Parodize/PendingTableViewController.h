//
//  PendingTableViewController.h
//  Parodize
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingTableViewController : UIViewController  

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet UITableView *pendingTableView;
@end
