//
//  Context.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject

+ (Context *) contextSharedManager;

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

//-(void)addIndicatorView:(UIView *)presentView
//-(void)removeIndicatorView

@end
