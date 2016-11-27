//
//  NSMutableURLRequest+Additions.m
//  TheGreatCourses
//
//  Created by Praveen Matanam on 05/02/15.
//  Copyright (c) 2015 mportal. All rights reserved.
//

#import "NSMutableURLRequest+Additions.h"
#import <objc/runtime.h>

static char const * const userInfoRef = "userInfo";

@implementation NSMutableURLRequest (Additions)

@dynamic userInfo;

- (NSDictionary *) userInfo
{
	return objc_getAssociatedObject(self, &userInfoRef);
}

- (void) setUserInfo:(NSDictionary *) userInfo
{
	objc_setAssociatedObject(self, &userInfoRef, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
