//
//  Context.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "Context.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@implementation Context
{
    UIActivityIndicatorView *activityIndicator;
}

static Context *contextManager_instance = nil;

+ (Context *)contextSharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contextManager_instance = [[self alloc] init];
    });
    return contextManager_instance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(UIColor *)setBackgroundForView:(UIView *)selectedView withImageName:(NSString *)backImage
{
    
    UIGraphicsBeginImageContext(selectedView.frame.size);
    [[UIImage imageNamed:backImage] drawInRect:selectedView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
}
-(void)makeClearNavigationBar:(UINavigationController *)navController
{
    [navController.navigationBar setHidden:NO];
    navController.navigationBar.barStyle = 1;
    [navController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.translucent = YES;
    navController.view.backgroundColor = [UIColor clearColor];
    navController.navigationBar.backgroundColor = [UIColor clearColor];
    [navController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(void)addIndicatorView:(UIView *)presentView
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = presentView.center;
    [presentView addSubview: activityIndicator];
    [activityIndicator startAnimating];
}
-(void)removeIndicatorView
{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    activityIndicator=nil;
}
- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}
-(void)roundImageView:(UIImageView *)imgView
{
    imgView.layer.cornerRadius=imgView.frame.size.height/2;
   
    imgView.layer.borderColor=[self colorWithRGBHex:PROFILE_COLOR].CGColor;
    imgView.layer.borderWidth=1.0f;
     imgView.layer.masksToBounds=YES;
    imgView.clipsToBounds=YES;
}

-(void)setLoginUser:(BOOL)status forKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = [NSUserDefaults standardUserDefaults];
    [sharedUserDefaults setBool:status forKey:EMAIL_LOGIN];
    [sharedUserDefaults synchronize];
}
-(BOOL)getLoginUserStatusForKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = [NSUserDefaults standardUserDefaults];
    return [sharedUserDefaults boolForKey:key];
}

-(void)deleteCoredataForEntity:(NSString *)entity
{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDg managedObjectContext];
    NSFetchRequest * fetchReq = [[NSFetchRequest alloc] init];
    [fetchReq setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    [fetchReq setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * profile = [context executeFetchRequest:fetchReq error:&error];
    //error handling goes here
    for (NSManagedObject * str in profile) {
        [context deleteObject:str];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
   // [self clearNSUserDefaults];
    
    
}

#pragma mark DateTime interval

/*
-(NSString*)setDateInterval:(NSString*)string
{
    NSString *formatDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEE MM dd HH:mm:ss yyyy"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormat dateFromString:string];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEE MMM d, YYYY"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    
    NSDate *currentDate=[NSDate date];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    
    long seconds = lroundf(interval); // Modulo (%) operator below needs int or long
    
    int hour = (seconds%3600);
    int mins = (seconds%3600)/60;
    int secs = seconds%60;
    
    if (hour==0)
    {
        if (mins==0)
        {
            formatDate=[NSString stringWithFormat:@"%d Seconds ago",secs];
        }
        else
        {
            formatDate=[NSString stringWithFormat:@"%d minutes ago",mins];
        }
    }
    else if(hour<=24)
    {
        formatDate=[NSString stringWithFormat:@"Today"];
    }
    else if(hour<=48)
    {
        formatDate=[NSString stringWithFormat:@"Yesterday"];
    }
    else
    {
        formatDate=dateStr;
    }
    
    return formatDate;
}*/
-(NSString*)setDateInterval:(NSString *)dateValueStr
{
    NSString *formatDate;
    
    double unixValue = [dateValueStr doubleValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEE MM dd HH:mm:ss yyyy"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixValue];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEE MMM d, YYYY"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    
    NSDate *currentDate=[NSDate date];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    
    long seconds = lroundf(interval); // Modulo (%) operator below needs int or long
    
    int hour = (seconds%3600);
    int mins = (seconds%3600)/60;
    int secs = seconds%60;
    
    if (hour==0)
    {
        if (mins==0)
        {
            formatDate=[NSString stringWithFormat:@"%d Seconds ago",secs];
        }
        else
        {
            formatDate=[NSString stringWithFormat:@"%d minutes ago",mins];
        }
    }
    else if(hour<=24)
    {
        formatDate=[NSString stringWithFormat:@"Today"];
    }
    else if(hour<=48)
    {
        formatDate=[NSString stringWithFormat:@"Yesterday"];
    }
    else
    {
        formatDate=dateStr;
    }
    
    return formatDate;
}
-(NSString *)setFirstLetterCapital:(NSString *)string{
    
    NSString *firstStr=[[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                             withString:firstStr];
    
    return cappedString;
}
#pragma mark Clear UserDefaults

-(void)clearNSUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
