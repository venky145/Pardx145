//
//  PGResponseObject.h
//  Parodize
//
//  Created by Apple on 16/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGResponseObject : NSObject

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *image;
@property (nonatomic,retain) NSString *caption;
@property (nonatomic,retain) NSString *stars;
@property (nonatomic,retain) NSString *starredByMe;
@property (nonatomic,retain) NSArray *time;


@end
/*
 'id': resp.ID,
 'image':resp.imageLink(),
 'caption':resp.caption,
 'stars':resp.stars,
 'time':resp.created_at},…],
 'time': unix time
 */
