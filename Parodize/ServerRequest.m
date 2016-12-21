//
//  ServerRequest.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 18/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "ServerRequest.h"
#import "CommonParodize.h"
#import "User_Profile.h"

@implementation ServerRequest

+ (ServerRequest *) sharedServerManager {
    
    static ServerRequest *sharedEngine = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      sharedEngine = [[ServerRequest alloc] init];
                  });
    
    return sharedEngine;
}

-(void)sendRequestURL:(NSString *)url forType:(eRequestType)requestType withDetails:(NSDictionary *)details forSender:(id)sender withHttpMethod:(eHttpMethod)httpType withHeader:(BOOL)headerStatus
{
    NSDictionary *userInfo = @{
                               @"sender": sender,
                               @"requesttype": [NSNumber numberWithInt:requestType],
                               @"postdata": details
                               };

    [self fetchDataForURL:url userInfo:userInfo postTypeMethod:httpType  headerAutherization:headerStatus];

}
-(void)sendRequestURL:(NSString *)url forType:(eRequestType)requestType forSender:(id)sender withHttpMethod:(eHttpMethod)httpType withHeader:(BOOL)headerStatus
{
    NSDictionary *userInfo = @{
                               @"sender": sender,
                               @"requesttype": [NSNumber numberWithInt:requestType]
                               };
    
    [self fetchDataForURL:url userInfo:userInfo postTypeMethod:httpType  headerAutherization:headerStatus];
}

#pragma mark Facebook Registration
-(void)registerFacebookAccount:(NSDictionary *)details forSender:(id)sender  {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,FB_API];
    
    [self sendRequestURL:requestURL forType:eCloudFBRegisterationRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:NO];
    
}
#pragma mark Email Registration
-(void)registerEmailAccount:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,SIGN_UP_API];
   
    [self sendRequestURL:requestURL forType:eCloudEmailRegisterationRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:NO];
}
#pragma mark Update Profile Picture
-(void)updateProfilePicture:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,PROFILE_PICTURE];
    
    [self sendRequestURL:requestURL forType:eCloudUpdateProfileImageRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
#pragma mark Update Profile Picture
-(void)updateInformation:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,INFORMATION_API];
    
    [self sendRequestURL:requestURL forType:eCloudUpdateInformationRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
#pragma mark Update Profile Picture
-(void)loginAccount:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,LOGIN_API];
    
    [self sendRequestURL:requestURL forType:eCloudLoginRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
#pragma mark Update Profile Details
-(void)requestProfileDetails:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,PROFILE_DETAILS];
    
    [self sendRequestURL:requestURL forType:eCloudProfileDetailsRequestGet forSender:sender withHttpMethod:eGET withHeader:YES];
}

-(void)requestFriendsList:(NSDictionary *)list forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,FRIENDS_LIST];
    
//    [self sendRequestURL:requestURL forType:eCloudFreindsListRequestGet forSender:sender withHttpMethod:eGET withHeader:YES];
    [self sendRequestURL:requestURL forType:eCloudFreindsListRequestGet withDetails:list forSender:sender withHttpMethod:ePOST withHeader:YES];
}

-(void)postNewChallenge:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,NEW_CHALLENGE];
    
    [self sendRequestURL:requestURL forType:eCloudNewChallengeRequestPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}

-(void)requestAcceptChallenges:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,ACCEPT_CHALLENGE];
    
//    [self sendRequestURL:requestURL forType:eCloudAcceptChallengeRequestGet forSender:sender withHttpMethod:eGET withHeader:YES];
    
    [self sendRequestURL:requestURL forType:eCloudAcceptChallengeRequestGet withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
-(void)requestCompletedChallenges:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,COMPLETED_RESPONSE];
    
//    [self sendRequestURL:requestURL forType:eCloudCompletedChallengeRequestGet forSender:sender withHttpMethod:eGET withHeader:YES];
    
    [self sendRequestURL:requestURL forType:eCloudCompletedChallengeRequestGet withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
-(void)requestPendingChallenges:(NSDictionary *)details forSender:(id)sender{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,PENDING_REQUEST];
    
    [self sendRequestURL:requestURL forType:eCloudPendingChallengeRequestGet withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
    
}
-(void)postDeviceToken:(NSDictionary *)details forSender:(id)sender
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,DEVICE_TOKEN_REQUEST];
    
    [self sendRequestURL:requestURL forType:eCloudDeviceTokenPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
}
-(void)friendsDetails:(NSDictionary *)details forSender:(id)sender{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,FRIEND_DETAILS];
    
    [self sendRequestURL:requestURL forType:eCloudFriendDetailsPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
    
}
-(void)friendRequests:(NSDictionary *)details forSender:(id)sender{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,ACCEPT_FRIEND];
    
        [self sendRequestURL:requestURL forType:eCloudFriendRequestsGet forSender:sender withHttpMethod:eGET withHeader:YES];
}
-(void)friendRequestAccept:(NSDictionary *)details forSender:(id)sender{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,ACCEPT_FRIEND];
    
    [self sendRequestURL:requestURL forType:eCloudFriendRequestsPost withDetails:details forSender:sender withHttpMethod:ePOST withHeader:YES];
    
}
- (void) fetchDataForURL:(NSString *) url userInfo:(NSDictionary *) userInfo postTypeMethod:(int)methodType headerAutherization:(BOOL)iSheadReqAuth
{
    NSString *requestMethod;
    NSString *userInfoKey;
    if(methodType == ePOST){
        requestMethod = @"POST";
        userInfoKey=@"postdata";
    }
    else if (methodType == eGET){
        requestMethod = @"GET";
        userInfoKey=@"parameters";
    }
    else if (methodType == ePUT)
        requestMethod = @"PUT";
    else if (methodType == eDeLETE)
        requestMethod = @"DELETE";
    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:url
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];

    request.userInfo = userInfo;
    request.timeoutInterval = 60.0;
    
    if ([userInfo objectForKey:userInfoKey] != nil)
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[userInfo objectForKey:userInfoKey] options:NSUTF8StringEncoding error:&error];
        [request setHTTPBody:(NSMutableData *)data];
    }
//    if (methodType == eGET) {
//         [request setValue:@"multipart/form-data" forHTTPHeaderField: @"Content-Type"];
//    }else{
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   // }

    if(iSheadReqAuth) {
        NSLog(@" Autherization Header required");
        NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
        [request setValue:[User_Profile getParameter:AUTH_VALUE] forHTTPHeaderField:@"Authorization" ];
       // [request setValue:0 forHTTPHeaderField:@"next" ];

    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
   // operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(responseObject)
         {
             [self processResponse:responseObject operation:operation request:request];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         NSDictionary *userInfo = request.userInfo;
         id<ServerRequestDelegate> sender = [userInfo objectForKey:@"sender"];
         if ([userInfo objectForKey:@"entityId"]) {
             NSNumber *uniqueId = [userInfo objectForKey:@"entityId"];
             [self.requestor  webEngine:self sender:sender requestDidFailWithError:error forId:uniqueId];
         } else {
             [self.requestor  webEngine:self sender:sender requestDidFailWithRequest:error];
         }
     }];
    
    [manager.operationQueue addOperation:operation];
    
}

- (void) processResponse:(id) responseObject operation:(AFHTTPRequestOperation *) operation request:(NSMutableURLRequest *) request
{
    NSDictionary *userInfo = request.userInfo;
    id<ServerRequestDelegate> sender = [userInfo objectForKey:@"sender"];
    eRequestType requestType = (eRequestType)[[userInfo objectForKey:@"requesttype"] intValue];
    NSLog(@"requestType: %d", requestType);
    switch (requestType)
    {
        case eCloudFBRegisterationRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didCloudGetUserRegisterationRequest: responseObject];
            break;
        case eCloudEmailRegisterationRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didCloudGetUserRegisterationRequest: responseObject];
            break;
        case eCloudLoginRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didLoggedIn: responseObject];
            break;
        case eCloudUpdateProfileImageRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didProfileImageUpdated: responseObject];
            break;
        case eCloudUpdateInformationRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didInformationUpdated: responseObject];
            break;
        case eCloudProfileDetailsRequestGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetProfileDetails: responseObject];
            break;
        case eCloudFreindsListRequestGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetFriendsList: responseObject];
            break;
        case eCloudNewChallengeRequestPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didPostNewChallenge: responseObject];
            break;
            
        case eCloudAcceptChallengeRequestGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetAcceptedChallenges: responseObject];
            break;
            
        case eCloudCompletedChallengeRequestGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetCompletedChallenges: responseObject];
            break;
        case eCloudPendingChallengeRequestGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetPendingChallenges: responseObject];
            break;
            
        case eCloudDeviceTokenPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didPostDeviceToken: responseObject];
            break;
        case eCloudFriendDetailsPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetFriendDetails: responseObject];
            break;
            
        case eCloudFriendRequestsGet:
            [[DataManager sharedDataManager] webEngine:self sender:sender didGetFriendRequests: responseObject];
            break;
        case eCloudFriendRequestsPost:
            [[DataManager sharedDataManager] webEngine:self sender:sender didPostFriendAccept: responseObject];
            break;
        
        default:
            break;
    }
}

-(void)profileDetails:(void (^)(void))block
{
    
}

@end
