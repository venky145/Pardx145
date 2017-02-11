//
//  DataManager.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 18/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "DataManager.h"
#import "ServerRequest.h"

@implementation DataManager

@synthesize isLoggedUser;

+ (DataManager *) sharedDataManager {
    
    static DataManager *sharedData = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      sharedData = [[DataManager alloc] init];
                  });
    
    return sharedData;
}

-(void)registerFacebookAccount:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager]  registerFacebookAccount:details forSender:sender];
}
-(void)registerEmailAccount:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager]  registerEmailAccount:details forSender:sender];
}
-(void)updateProfilePicture:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager]  updateProfilePicture:details forSender:sender];
}
-(void)updateInformation:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager]  updateInformation:details forSender:sender];
}
-(void)loginAccount:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] loginAccount:details forSender:sender];
}
-(void)requestProfileDetails:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] requestProfileDetails:details forSender:sender];
}

-(void)requestFriendsList:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] requestFriendsList:details forSender:sender];
}

-(void)postNewChallenge:(NSDictionary *)details forSender:(id)sender
{
   [[ServerRequest sharedServerManager] postNewChallenge:details forSender:sender];
}
-(void)requestAcceptChallenges:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] requestAcceptChallenges:details forSender:sender];
}
-(void)requestAcceptParticular:(NSDictionary *)details forSender:(id)sender{
     [[ServerRequest sharedServerManager] requestAcceptParticular:details forSender:sender];
}
-(void)requestCompletedChallenges:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] requestCompletedChallenges:details forSender:sender];
}
-(void)requestPendingChallenges:(NSDictionary *)details forSender:(id)sender{
    
    [[ServerRequest sharedServerManager] requestPendingChallenges:details forSender:sender];
}
-(void)postDeviceToken:(NSDictionary *)details forSender:(id)sender
{
    [[ServerRequest sharedServerManager] postDeviceToken:details forSender:sender];
}
-(void)friendsDetails:(NSDictionary *)details forSender:(id)sender{
    
    [[ServerRequest sharedServerManager] friendsDetails:details forSender:sender];
}
-(void)friendRequests:(NSDictionary *)details forSender:(id)sender{
    
    [[ServerRequest sharedServerManager] friendRequests:details forSender:sender];
    
}
-(void)friendRequestAccept:(NSDictionary *)details forSender:(id)sender{
    
    [[ServerRequest sharedServerManager] friendRequestAccept:details forSender:sender];
}

#pragma mark ServerRequestDelegate Methods

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray {
    
    if([sender respondsToSelector:@selector(didCloudGetUserRegisterationRequest:)])
        [sender didCloudGetUserRegisterationRequest:dataDictionaray];
    
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didProfileImageUpdated:)])
        [sender didProfileImageUpdated:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didInformationUpdated:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didInformationUpdated:)])
        [sender didInformationUpdated:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didLoggedIn:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didLoggedIn:)])
        [sender didLoggedIn:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetProfileDetails:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didGetProfileDetails:)])
        [sender didGetProfileDetails:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetFriendsList:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didGetFriendsList:)])
        [sender didGetFriendsList:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didPostNewChallenge:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didPostNewChallenge:)])
        [sender didPostNewChallenge:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetAcceptedChallenges:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didGetAcceptedChallenges:)])
        [sender didGetAcceptedChallenges:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetCompletedChallenges:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didGetCompletedChallenges:)])
        [sender didGetCompletedChallenges:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetPendingChallenges:(NSMutableDictionary *) dataDictionaray{
    
    if([sender respondsToSelector:@selector(didGetPendingChallenges:)])
        [sender didGetPendingChallenges:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didPostDeviceToken:(NSMutableDictionary *) dataDictionaray
{
    if([sender respondsToSelector:@selector(didPostDeviceToken:)])
        [sender didPostDeviceToken:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetFriendDetails:(NSMutableDictionary *) dataDictionaray{
    
    if([sender respondsToSelector:@selector(didGetFriendDetails:)])
        [sender didGetFriendDetails:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetFriendRequests:(NSMutableDictionary *) dataDictionaray{
    
    if([sender respondsToSelector:@selector(didGetFriendRequests:)])
        [sender didGetFriendRequests:dataDictionaray];
}

- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didPostFriendAccept:(NSMutableDictionary *) dataDictionaray{
    
    if([sender respondsToSelector:@selector(didPostFriendAccept:)])
        [sender didPostFriendAccept:dataDictionaray];
}
- (void) webEngine:(ServerRequest *) serverRequest  sender:(id) sender didGetAcceptedParticular:(NSMutableDictionary *) dataDictionaray{
    if([sender respondsToSelector:@selector(didGetAcceptedParticular:)])
        [sender didGetAcceptedParticular:dataDictionaray];
}
#pragma Error

- (void) webEngine:(ServerRequest *) webEngine  sender:(id) sender requestDidFailWithRequest:(NSError *) error {
    if([sender respondsToSelector:@selector(requestDidFailWithRequest:)])
        [sender requestDidFailWithRequest:error];
}



//- (void) webEngine:(ServerRequest *) webEngine  sender:(id) sender requestDidFailWithError:(NSError *) error forId:(NSNumber *)uniqueId {
//    if([sender respondsToSelector:@selector(requestDidFailWithError:forId:)])
//        [sender requestDidFailWithError:error forId:uniqueId];
//}


@end
