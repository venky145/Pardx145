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
#define UPPER_COLOR  0x3AC4B4
#define LOWER_COLOR 0x189689


#pragma mark Server-API's

#define kBaseAPI   @"https://parodizeserverapi.com/parodize/version_one/"
//https://parodizeserverapi.com/parodize/version_one/user/reset/password

#define DELETE_ACCOUNT @"Delete Account"

#define SIGN_UP_API            @"user/signup"
#define FB_API                 @"user/signup/facebook"
#define LOGIN_API              @"user/login"
#define RESET_PASSWORD         @"user/reset/password"
#define PROFILE_PICTURE        @"user/update/profilepicture"
#define INFORMATION_API        @"user/update/information"
#define PROFILE_DETAILS        @"user/profile"
#define USER_NAME              @"user/username/add"
//#define FRIENDS_LIST           @"user/friends/list"
#define FRIENDS_LIST           @"user/friends/list/lazy"
#define FRIENDS_CHALLENGES     @"user/friends/timeline/challenges"
#define FRIENDS_RESPONSES     @"user/friends/timeline/responses"
#define VISIBILITY              @"completed/visibility"

#define NEW_CHALLENGE          @"challenge/new"
#define ACCEPT_PARTICULAR      @"challenge/accept"
#define ACCEPT_CHALLENGE       @"challenge/accept/lazy"
#define ACCEPT_RESPONSE        @"challenge/accept/response"
#define ACCEPT_IGNORE          @"challenge/accept/ignore"
//#define COMPLETED_RESPONSE     @"completed"
#define COMPLETED_RESPONSE     @"completed/lazy"
#define PENDING_REQUEST        @"pending/lazy"
#define SEARCH_FRIEND          @"user/search"
#define ACCEPT_FRIEND          @"user/friendrequest/accept"
#define NEW_FRIEND_REQUEST     @"user/friendrequest/new"

//Play ground API
#define pgBASE_API             @"https://parodizeserverapi.com/parodize/version_one/playground/"
#define PG_NEW                 @"challenge/new"
#define PG_SCAN                @"challenge/scan"
#define PG_RESPONSE            @"response"
#define PG_STARS               @"response/stars_increment"
#define PG_SUGGEST             @"tag/suggest"
#define PG_RELATED             @"tag/related"
#define PG_RESPONSES_LOAD      @"challenge/responses"
#define PG_MYPOSTS             @"challenge/my_posts"

//Share API
#define SHARE_REQUEST          @"completed/shared"
#define COMBINE_IMAGE          @"combined/url"

#define SETTINGS               @"user/settings"
#define DEACTIVATE_ACCOUNT     @"user/deactivate"

//= https://parodizeserverapi.com/parodize/version_one/playground/challenge/my_posts

//user/friendrequest/accept

#define DEVICE_TOKEN_REQUEST   @"user/update/device/token"
#define FRIEND_DETAILS         @"user/friends/profile/view"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//Notification Category

typedef enum category_type{
    
    new_Challenge = 101,
    complete_Challenge,
    friend_Request,
    friend_Accept,
    profile_notify = 201
    
} notificationType;
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
    eCloudFriendDetailsPost,
    eCloudFriendRequestsGet,
    eCloudFriendRequestsPost,
    eCloudAcceptParticularRequestPost,
    
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

#define SERVER_ERROR  @"Error"

#define SERVER_REQ_ERROR @"Server internal issue, unable to communicate"

//CoreData Constants

#define USER_PROFILE @"User_Profile"
#define AUTH_VALUE   @"Auth_Value"
#define EMAIL_STATUS @"Email_Status"

#define EMAIL_LOGIN @"EMAIL_LOGIN"

#define PROFILE_UPDATE  @"ProfileUpdated"

#define RESPONSE_UPDATE  @"ResponseUpdate"

#define DEVICE_TOKEN   @"deviceToken"

#define CAPTION_STR @"No Caption"

#define DEFAULT_IMAGE @"imageBackground"

#define SETTINGS_DEFAULT @"Settings"

//#define macro




#endif /* CommonParodize_h */
