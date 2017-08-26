//
//  Tags+CoreDataClass.m
//  Parodize
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "Tags+CoreDataClass.h"
#import "AppDelegate.h"

@implementation Tags

+(void)saveTagDetails:(NSDictionary *)infoDict withCompletionBlock:(void (^)(BOOL flag,NSNumber *id,NSNumber *posts,NSString *tag))savedStatus{
    
    NSString *keyStr = @"tag";
    
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", keyStr,[infoDict objectForKey:@"tag"]];
    [request setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tags" inManagedObjectContext:appDg.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    Tags *tagDetail = [[appDg.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    
    if (!tagDetail) {
        
        tagDetail=[NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:appDg.managedObjectContext];
        for (NSString *key in infoDict) {
            
            NSString *dataText=[infoDict objectForKey:key];
            
            if ([dataText isKindOfClass:[NSNull class]]){
                dataText=@"";
            }
            
            [tagDetail setValue:dataText forKey:key];
        }
    }
    
    BOOL isSaved=[appDg.managedObjectContext save:&error];
    savedStatus(isSaved,tagDetail.id,tagDetail.posts,tagDetail.tag);
}

+(NSArray *)fetchTagDetails:(NSString *)entityString{
    
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDg.managedObjectContext reset];
    __block NSArray* accountDetails;
    [appDg.managedObjectContext performBlockAndWait:^{//performBlockAndWait
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        accountDetails = [[appDg.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
    }];
    
    if (accountDetails.count>0) {
        
        return accountDetails;
    }
    
    return nil;
}

@end
