//
//  FriendsViewController.h
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : ActivityBaseViewController<UISearchBarDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@end
