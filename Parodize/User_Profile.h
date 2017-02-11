//
//  User_Profile.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 07/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface User_Profile : NSManagedObject
{
    AppDelegate *appDg;
}

// Insert code here to declare functionality of your managed object subclass
+(void)saveUserProfile:(NSDictionary *)infoDict withCompletionBlock:(void (^)(BOOL flag,NSString *firstName,NSString *lastName,NSString *emailID))savedStatus;

+(void)deleteObject:(NSManagedObject *)object withCompletionBlock:(void (^)(BOOL flag))deleteStatus;

+(User_Profile *)fetchDetailsFromDatabase:(NSString *)entityString;

+(BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName;

+(NSString *)getParameter:(NSString *)paramValue;

+(void)updateValue:(NSString *)key withValue:(int)score;

@end

NS_ASSUME_NONNULL_END

#import "User_Profile+CoreDataProperties.h"
