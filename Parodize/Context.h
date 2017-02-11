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

-(void)setLoginUser:(BOOL)status forKey:(NSString *)key;
-(BOOL)getLoginUserStatusForKey:(NSString *)key;

-(UIColor *)setBackgroundForView:(UIView *)selectedView withImageName:(NSString *)backImage;

-(void)makeClearNavigationBar:(UINavigationController *)navController;

- (UIColor *)colorWithRGBHex:(UInt32)hex;

-(NSData *)dataFromBase64EncodedString:(NSString *)string;

-(void)roundImageView:(UIImageView *)imgView;

-(void)deleteCoredataForEntity:(NSString *)entity;

-(void)clearNSUserDefaults;

-(NSString*)setDateInterval:(NSString*)string;

-(NSString *)setFirstLetterCapital:(NSString *)string;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

-(void)drawBorder:(UIImageView *)drawView;

-(void)requestProfileDetails;

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

-(NSString *)assignFriendName:(FriendsObject *)_friendObj;
//-(void)setNotificationType:(notificationType *)notification;

//-(void)addIndicatorView:(UIView *)presentView
//-(void)removeIndicatorView

@end
