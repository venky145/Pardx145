//
//  Tags+CoreDataProperties.h
//  Parodize
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "Tags+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tags (CoreDataProperties)

+ (NSFetchRequest<Tags *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *posts;
@property (nullable, nonatomic, copy) NSString *tag;

@end

NS_ASSUME_NONNULL_END
