//
//  User_Profile+CoreDataProperties.m
//  Parodize
//
//  Created by Apple on 27/01/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "User_Profile+CoreDataProperties.h"

@implementation User_Profile (CoreDataProperties)

+ (NSFetchRequest<User_Profile *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User_Profile"];
}

@dynamic about;
@dynamic auth;
@dynamic email;
@dynamic emailVerified;
@dynamic firstname;
@dynamic gender;
@dynamic id;
@dynamic lastname;
@dynamic phone;
@dynamic profilePicture;
@dynamic username;
@dynamic score;

@end
