//
//  User_Profile+CoreDataProperties.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 07/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User_Profile.h"

NS_ASSUME_NONNULL_BEGIN

@interface User_Profile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSString *firstname;
@property (nullable, nonatomic, retain) NSString *lastname;
@property (nullable, nonatomic, retain) NSString *profilePicture;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *auth;
@property (nullable, nonatomic, retain) NSNumber *emailVerified;
@property (nullable, nonatomic, retain) NSNumber *id;

@end

NS_ASSUME_NONNULL_END
