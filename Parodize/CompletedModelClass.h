//
//  CompletedModelClass.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompletedModelClass : NSObject

@property (nonatomic,retain) NSDictionary *from;
@property (nonatomic,retain) NSString *challengeThumbnail;
@property (nonatomic,retain) NSString *responseThumbnail;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSString *caption;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *id;


//'completed': [{'id':activity.ID,
//    ​​​​​'from': {'email': sender.email,
//        ​​​​​​'firstname': sender.first_name,
//        ​​​​​​'lastname': sender.last_name,
//        ‘thumbnail’: sender profile thumbnail-base64},
//    ​​'challengeThumbnail': challenge image base64,
//    ​​'responseThumbnail': response image base64,
//    ​​'message': respImage.message,
//    ​​​​​'caption': respImage.caption,
//    ​​'time': time responded at}, …],

@end