//
//  AcceptModelClass.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 07/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceptModelClass : NSObject

@property(strong,nonatomic) NSString *caption;
@property(strong,nonatomic) NSString *message;
@property(strong,nonatomic) NSString *thumbnail;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSNumber *id;
@property(strong,nonatomic) NSDictionary *from;

@end
