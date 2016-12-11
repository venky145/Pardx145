//
//  ServerRequestDelegate.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 22/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

@class ServerRequest;
@class ASIHTTPRequest;

@protocol ServerRequestDelegate <NSObject>



@optional
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didLoggedIn:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didInformationUpdated:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetProfileDetails:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetFriendsList:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didPostNewChallenge:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetAcceptedChallenges:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetCompletedChallenges:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetPendingChallenges:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didPostDeviceToken:(NSMutableDictionary *) dataDictionaray;

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetFriendDetails:(NSMutableDictionary *) dataDictionaray;



//Did failed request
- (void) webEngine:(ServerRequest *) webEngine  sender:(id) sender requestDidFailWithRequest:(NSError *) error ;
- (void) webEngine:(ServerRequest *) webEngine  sender:(id) sender requestDidFailWithError:(NSError *) error forId:(NSNumber *)uniqueId;



@end
