//
//  User_Profile+CoreDataProperties.h
//  Parodize
//
//  Created by Apple on 27/01/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "User_Profile.h"


NS_ASSUME_NONNULL_BEGIN

@interface User_Profile (CoreDataProperties)

+ (NSFetchRequest<User_Profile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *about;
@property (nullable, nonatomic, copy) NSString *auth;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSNumber *emailVerified;
@property (nullable, nonatomic, copy) NSString *firstname;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *lastname;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *profilePicture;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSNumber *score;

@end

NS_ASSUME_NONNULL_END
