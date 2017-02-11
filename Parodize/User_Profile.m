//
//  User_Profile.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 07/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "User_Profile.h"
#import "AppDelegate.h"

@implementation User_Profile

// Insert code here to add functionality to your managed object subclass

+(void)saveUserProfile:(NSDictionary *)infoDict withCompletionBlock:(void (^)(BOOL flag,NSString *firstName,NSString *lastName,NSString *emailID))savedStatus
{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Profile" inManagedObjectContext:appDg.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    User_Profile *userProfile = [[appDg.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    
    if (userProfile)
    {
        for (NSString *key in infoDict) {
            
            NSString *dataText=[infoDict objectForKey:key];
            
            if ([dataText isKindOfClass:[NSNull class]]){
                dataText=@"";
            }
            
            
            [userProfile setValue:dataText forKey:key];
            
        }
        
    }
    else
    {
        userProfile=nil;
        userProfile=[NSEntityDescription insertNewObjectForEntityForName:@"User_Profile" inManagedObjectContext:appDg.managedObjectContext];
        
        
        for (NSString *key in infoDict) {
            
            NSString *dataText=[infoDict objectForKey:key];
            
            if ([dataText isKindOfClass:[NSNull class]]){
                dataText=@"";
            }
            
            [userProfile setValue:dataText forKey:key];
        }
        
    }
    // Save the object to persistent store
    
    BOOL isSaved=[appDg.managedObjectContext save:&error];
    
    if (!isSaved) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    savedStatus(isSaved,userProfile.firstname,userProfile.lastname,userProfile.email);
}

+(void)deleteObject:(NSManagedObject *)object withCompletionBlock:(void (^)(BOOL flag))deleteStatus
{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appDg.managedObjectContext deleteObject:object];
    
    NSError *error;
    
    BOOL status=[appDg.managedObjectContext save:&error];
    
    if (!status) {
        // Handle the error.
        
        NSLog(@"Error delete object");
    }
    
    deleteStatus(status);
}

+(User_Profile *)fetchDetailsFromDatabase:(NSString *)entityString;
{
    
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDg.managedObjectContext reset];
    __block NSArray* accountDetails;
    [appDg.managedObjectContext performBlockAndWait:^{//performBlockAndWait
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        accountDetails = [[appDg.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
    }];
    
    if (accountDetails.count>0) {
        
        User_Profile *userProfile=[accountDetails objectAtIndex:0];
        
        return userProfile;
    }
    
    return nil;
}
+(void)updateValue:(NSString *)key withValue:(int)score{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDg managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User_Profile" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
//     User_Profile *userProfile = [NSEntityDescription insertNewObjectForEntityForName:@"User_Profile" inManagedObjectContext:context];
    
    if (results>0) {
        User_Profile* userProfile = [results objectAtIndex:0];
    
        userProfile.score=[NSNumber numberWithInt:score];
    }

    BOOL isSaved=[appDg.managedObjectContext save:&error];
    
    if (!isSaved) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}
+ (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName;
{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:appDg.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    User_Profile *userProfile = [[appDg.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (error) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    if (!userProfile) {
        return NO;
    }
    return YES;
}
+(NSString *)getParameter:(NSString *)paramValue
{
    User_Profile *userPro= [User_Profile fetchDetailsFromDatabase:@"User_Profile"];
    
    if (userPro) {
        if (AUTH_VALUE) {
            return userPro.auth;
        }else if(EMAIL_STATUS)
            return [NSString stringWithFormat:@"%@",userPro.emailVerified];
            
        
    }
    return @"";
}


@end
