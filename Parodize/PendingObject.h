//
//  PendingObject.h
//  Parodize
//
//  Created by Apple on 13/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingObject : NSObject

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSArray *from;
@property(nonatomic,retain) NSString *challengeImage;
@property(nonatomic,retain) NSString *challengeThumbnail;
@property(nonatomic,retain) NSString *next;
@property(nonatomic,retain) NSString *recipientsGif;
@property(nonatomic,retain) NSString *caption;
@property(nonatomic,retain) NSString *time;

@end


