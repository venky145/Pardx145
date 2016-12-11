//
//  CommonParodize.h
//  Parodize
//
//  Created by administrator on 28/10/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#ifndef CommonParodize_h
#define CommonParodize_h


//Parse Table Classes
#pragma mark Parse Classes

#define NewChallenge            @"NewChallenge"

//#define TW_CONSUMER_SECRET  @"BAm2IbnTF25Etkilz5DCSHMiOYBab3LvyYPPpu3U"
//#define TW_CONSUMER_KEY     @"13LrYo4W1bRw5VPP7jrac5Fya"

#define TW_CONSUMER_SECRET  @"HhQsGwWbAuda9eUVfYueBEo5ibYiIMGp2XqIGleFpsUsdUdKSd"
#define TW_CONSUMER_KEY     @"ec1yZpVqJoZNmMRdIfQRhb06R"

#define PROFILE_COLOR  0x2ED9CE


#pragma mark Server-API's

#define kBaseAPI   @"http://parodizeserverapi.com/parodize/version_one/"

#define SIGN_UP_API            @"user/signup"
#define FB_API                 @"user/signup/facebook"
#define LOGIN_API              @"user/login"
#define PROFILE_PICTURE        @"user/update/profilepicture"
#define INFORMATION_API        @"user/update/information"
#define PROFILE_DETAILS        @"user/profile"
//#define FRIENDS_LIST           @"user/friends/list"
#define FRIENDS_LIST           @"user/friends/list/lazy"
#define NEW_CHALLENGE          @"challenge/new"
//#define ACCEPT_CHALLENGE       @"challenge/accept"
#define ACCEPT_CHALLENGE       @"challenge/accept/lazy"
#define ACCEPT_RESPONSE        @"challenge/accept/response"
//#define COMPLETED_RESPONSE     @"completed"
#define COMPLETED_RESPONSE     @"completed/lazy"
#define PENDING_REQUEST        @"pending/lazy"
#define SEARCH_FRIEND          @"user/search/"
#define ACCEPT_FRIEND          @"user/friendrequest/accept"
#define NEW_FRIEND_REQUEST     @"user/friendrequest/new"

//user/friendrequest/accept

#define DEVICE_TOKEN_REQUEST   @"user/update/device/token"
#define FRIEND_DETAILS         @"user/friends/profile/view"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/* Server Request Types */
typedef enum _RequestType
{
    eCloudRegisterationUserRequestGet,
    eCloudFBRegisterationRequestPost,
    eCloudLoginRequestPost,
    eCloudEmailRegisterationRequestPost,
    eCloudUpdateProfileImageRequestPost,
    eCloudUpdateInformationRequestPost,
    eCloudProfileDetailsRequestGet,
    eCloudFreindsListRequestGet,
    eCloudNewChallengeRequestPost,
    eCloudAcceptChallengeRequestGet,
    eCloudCompletedChallengeRequestGet,
    eCloudPendingChallengeRequestGet,
    eCloudDeviceTokenPost,
    eCloudFriendDetailsPost
    
} eRequestType;

typedef enum _HttpMethod {
    ePOST,
    eGET,
    ePUT,
    eDeLETE
}eHttpMethod;

//Server Response constants
//Login (or) SignUp
#define RESPONSE_SUCCESS @"success"
#define RESPONSE_ERROR @"error"

//CoreData Constants

#define USER_PROFILE @"User_Profile"
#define AUTH_VALUE   @"Auth_Value"
#define EMAIL_STATUS @"Email_Status"

#define EMAIL_LOGIN @"EMAIL_LOGIN"

#define PROFILE_UPDATE  @"ProfileUpdated"

#define DEVICE_TOKEN   @"deviceToken"

//#define macro




#endif /* CommonParodize_h */
