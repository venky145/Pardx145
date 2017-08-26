//
//  PlayGroundObject.h
//  Parodize
//
//  Created by Apple on 16/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayGroundObject : NSObject

@property (nonatomic,retain) NSString *caption;
@property (nonatomic,retain) NSString *distance;
@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *image;
@property (assign) int responsesCount;
@property (nonatomic,retain) NSString *time;

@end

/*
 caption = "Welcome to #pokemon";
 distance = "3903.465047115787";
 id = 38;
 image = "https://parodizeserverapi.com/parodize/version_one/playground/challenge/image/eyJ0eXBlIjoiY2giLCJpbSI6Mzh9.kiH_q-YVMv2XEUTVhj0y5JIB2uA";
 responses =             (
 );
 time = "1489053796.96925";
 */
