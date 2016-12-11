//
//  DataManagerDelegate.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 22/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"


@protocol DataManagerDelegate <NSObject>

@optional
-(void) didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray;

-(void) didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray;

-(void) didLoggedIn:(NSMutableDictionary *) dataDictionaray;

-(void) didInformationUpdated:(NSMutableDictionary *) dataDictionaray;

-(void) didGetProfileDetails:(NSMutableDictionary *) dataDictionaray;

-(void) didGetFriendsList:(NSMutableDictionary *) dataDictionaray;

-(void) didPostNewChallenge:(NSMutableDictionary *) dataDictionary;

-(void) didGetAcceptedChallenges:(NSMutableDictionary *) dataDictionary;

-(void) didGetCompletedChallenges:(NSMutableDictionary *) dataDictionary;

-(void) didGetPendingChallenges:(NSMutableDictionary *) dataDictionary;

-(void) didPostDeviceToken:(NSMutableDictionary *) dataDictionary;


-(void) didGetFriendDetails:(NSMutableDictionary *) dataDictionary;

//Failure Delegate  method
-(void) requestDidFailWithRequest:(NSError *) error;
-(void) requestDidFailWithError:(NSError *) error forId:(NSNumber *)uniqueId;

@end
