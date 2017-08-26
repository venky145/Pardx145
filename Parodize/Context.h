//
//  Context.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsObject.h"

@interface Context : NSObject

+ (Context *) contextSharedManager;

@property (assign) int pushType;
@property (nonatomic,retain)AFHTTPRequestOperation *afOperation;


-(void)setLoginUser:(BOOL)status forKey:(NSString *)key;
-(BOOL)getLoginUserStatusForKey:(NSString *)key;

-(UIColor *)setBackgroundForView:(UIView *)selectedView withImageName:(NSString *)backImage;

-(void)makeClearNavigationBar:(UINavigationController *)navController;

-(void)makeNormalNavigationBar:(UINavigationController *)navController;

- (UIColor *)colorWithRGBHex:(UInt32)hex;

-(NSData *)dataFromBase64EncodedString:(NSString *)string;

-(void)roundImageView:(UIImageView *)imgView withValue:(double)value;

-(void)cornerImageView:(UIImageView *)imgView withValue:(double)value;

-(void)deleteCoredataForEntity:(NSString *)entity;

-(void)clearNSUserDefaults;

-(NSString*)setDateInterval:(NSString*)string;

-(NSString *)setFirstLetterCapital:(NSString *)string;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

-(void)drawBorder:(UIImageView *)drawView;

-(void)requestProfileDetails;

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

-(NSString *)assignFriendName:(FriendsObject *)_friendObj;

-(void)showAlertView:(UIViewController *)controller withMessage:(NSString *)alertString withAlertTitle:(NSString *)alertTitle;
//-(void)setNotificationType:(notificationType *)notification;

//-(void)addIndicatorView:(UIView *)presentView
//-(void)removeIndicatorView


//PlayGround
//-(void)requestGetRequestWithAPI:(NSString *)apiName withCompletionHandler:(void (^)(NSDictionary *dataDictionary, NSError *error))handler;
//
//-(void)requestPostRequestWithAPI:(NSString *)apiName withData:(NSString *)dataString withCompletionHandler:(void (^)(NSDictionary *data, NSError *error))handler;

- (void) pgfetchDataForURL:(NSString *) url userInfo:(NSDictionary *) userInfo postTypeMethod:(int)methodType headerAutherization:(BOOL)iSheadReqAuth withCompletionHandler:(void (^)(NSDictionary *data, NSError *error))handler;

@end
