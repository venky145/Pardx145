//
//  Tags+CoreDataClass.h
//  Parodize
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tags : NSManagedObject

+(void)saveTagDetails:(NSDictionary *)infoDict withCompletionBlock:(void (^)(BOOL flag,NSNumber *id,NSNumber *posts,NSString *tag))savedStatus;

+(NSArray *)fetchTagDetails:(NSString *)entityString;

@end

NS_ASSUME_NONNULL_END

#import "Tags+CoreDataProperties.h"
