//
//  FriendsViewController.h
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FriendsViewController : ActivityBaseViewController<UISearchBarDelegate,UIAlertViewDelegate,FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *processIndicator;


@end
