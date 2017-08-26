//
//  PendingUserObject.h
//  Parodize
//
//  Created by Apple on 13/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingUserObject : NSObject

@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *firstname;
@property(nonatomic,retain) NSString *lastname;
@property(nonatomic,retain) NSString *thumbnail;
@property(nonatomic,retain) NSString *id;

@end
