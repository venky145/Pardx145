//
//  CompletedViewController.h
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedModelClass.h"

@interface CompletedViewController : UIViewController
{
    NSMutableArray *completedArray;
    NSMutableArray *pendingArray;
}

- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *completedTableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property(strong,nonatomic) CompletedModelClass *modelClass;
@end
