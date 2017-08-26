//
//  NotificationViewController.h
//  Parodize
//
//  Created by Apple on 29/06/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObject.h"
#import "SettingsObject.h"

@interface NotificationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *notifyTableView;
@property (nonatomic) NotificationObject *notifications;
@property (nonatomic,retain) SettingsObject *settingObj;

@end
