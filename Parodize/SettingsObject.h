//
//  SettingsObject.h
//  Parodize
//
//  Created by Apple on 02/08/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationObject.h"

@interface SettingsObject : NSObject

@property (nonatomic,retain) NSString *notifSound;
@property (assign) int privateProfile;
@property (assign) int profileVisibility;
@property (nonatomic,retain) NotificationObject *notifications;

@end
