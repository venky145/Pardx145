//
//  Tags+CoreDataProperties.m
//  Parodize
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "Tags+CoreDataProperties.h"

@implementation Tags (CoreDataProperties)

+ (NSFetchRequest<Tags *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tags"];
}

@dynamic id;
@dynamic posts;
@dynamic tag;

@end
