//
//  FriendRequestViewController.h
//  Parodize
//
//  Created by Apple on 15/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestViewController : UIViewController


@property(weak) NSMutableArray *requestArray;
@property (weak, nonatomic) IBOutlet UITableView *requestsTableView;

@end
