//
//  AppDelegate.h
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AcceptModelClass.h"
#import "PlayGroundObject.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic) NSNumber *accpet_ID;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) PlayGroundObject *pgrespObj;

@property (nonatomic, retain) UIImage *getNewImage;

@property (nonatomic, retain) NSString *acceptImage;

@property (nonatomic, retain) NSString *friendId;

@property(assign) BOOL isImagePicker;

@property(nonatomic,strong) AcceptModelClass *acceptModel;

-(void)sendDeviceToken;


@end

