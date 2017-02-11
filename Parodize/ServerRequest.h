//
//  ServerRequest.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 18/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "NSMutableURLRequest+Additions.h"

@class DataManager;

@interface ServerRequest : NSObject

@property (nonatomic, strong) DataManager *requestor;

+ (ServerRequest *)sharedServerManager;

-(void)profileDetails:(void (^)(void))block;

-(void)registerFacebookAccount:(NSDictionary *)details forSender:(id)sender;

-(void)registerEmailAccount:(NSDictionary *)details forSender:(id)sender;

-(void)loginAccount:(NSDictionary *)details forSender:(id)sender;

-(void)updateProfilePicture:(NSDictionary *)details forSender:(id)sender;

-(void)updateInformation:(NSDictionary *)details forSender:(id)sender;

-(void)requestProfileDetails:(NSDictionary *)details forSender:(id)sender;

-(void)requestFriendsList:(NSDictionary *)list forSender:(id)sender;

-(void)postNewChallenge:(NSDictionary *)details forSender:(id)sender;

-(void)requestAcceptChallenges:(NSDictionary *)details forSender:(id)sender;

-(void)requestCompletedChallenges:(NSDictionary *)details forSender:(id)sender;

-(void)requestPendingChallenges:(NSDictionary *)details forSender:(id)sender;

-(void)postDeviceToken:(NSDictionary *)details forSender:(id)sender;

-(void)friendsDetails:(NSDictionary *)details forSender:(id)sender;

-(void)friendRequests:(NSDictionary *)details forSender:(id)sender;

-(void)friendRequestAccept:(NSDictionary *)details forSender:(id)sender;

-(void)requestAcceptParticular:(NSDictionary *)details forSender:(id)sender;


@end
