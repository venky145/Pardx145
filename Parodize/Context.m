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
#import "User_Profile.h"


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

-(void)makeNormalNavigationBar:(UINavigationController *)navController{
    [navController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:nil];
    navController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
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
-(void)roundImageView:(UIImageView *)imgView withValue:(double)value
{
    imgView.layer.cornerRadius=value/2;
    imgView.layer.borderColor=[self colorWithRGBHex:UPPER_COLOR].CGColor;
    imgView.layer.borderWidth=2.0f;
    imgView.layer.masksToBounds=YES;
    imgView.clipsToBounds=YES;
}
-(void)cornerImageView:(UIImageView *)imgView withValue:(double)value{
    imgView.layer.cornerRadius=value;
    
    imgView.layer.borderColor=[UIColor whiteColor].CGColor;
   imgView.layer.borderWidth=0.5f;
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
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:unixValue];
    
    NSDate *someDateInUTC = [NSDate dateWithTimeIntervalSince1970:unixValue];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
//    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";
    NSString *timeString = [timeFormatter stringFromDate: postDate];
    
//    NSLog(@".....%@",dateInLocalTimezone);
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEE MMM d, YYYY"];
    NSString* dateStr = [dateFormat stringFromDate:postDate];
    
//    NSDate *currentDate=[NSDate date];
    
//    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:postDate];
//    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
//    
//    
//    NSTimeInterval interval = [currentDate timeIntervalSinceDate:postDate];
//    
//    long seconds = lroundf(interval); // Modulo (%) operator below needs int or long
//    
////    int hour = (seconds/3600);
////    int mins = (seconds/60)/60;
//    int secs = seconds%60;
//    
//    int mins = (seconds/60) % 60;
//    int hour = (seconds/3600) % 60;
//    
//    if (hour==0)
//    {
//        if (mins==0)
//        {
//            formatDate=[NSString stringWithFormat:@"%d Seconds ago",secs];
//        }
//        else
//        {
//            formatDate=[NSString stringWithFormat:@"%d minutes ago",mins];
//        }
//    }
//    else if(hour<=24)
//    {
//        formatDate=[NSString stringWithFormat:@"Today %@",dateString];
//    }
//    else if(hour<=48)
//    {
//        formatDate=[NSString stringWithFormat:@"Yesterday %@",dateString];
//    }
//    else
//    {
//        formatDate=dateStr;
//    }
    
    NSString *checkStr=[self relativeDateStringForDate:postDate withDateString:timeString];
    
    
    
    if (checkStr.length==0) {
        formatDate=dateStr;
    }else{
        formatDate = checkStr;
    }
//    NSLog(@".......format : %@",formatDate);
    return formatDate;
}

- (NSString *)relativeDateStringForDate:(NSDate *)date withDateString:(NSString *)dateStr
{
    NSCalendarUnit units = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
        if (components.year > 0) {
            return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        } else if (components.month > 0) {
            return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
        } else if (components.weekOfYear > 0) {
            return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
        } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return [NSString stringWithFormat:@"Yesterday %@",dateStr];
        }
    } else {
        return [NSString stringWithFormat:@"Today %@",dateStr];
    }
    return @"";
}


-(NSString *)setFirstLetterCapital:(NSString *)string{
    
    NSString *firstStr=[[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                             withString:firstStr];
    
    return cappedString;
}


//Check for email format
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)drawBorder:(UIImageView *)drawView{
    
    drawView.layer.borderColor=[self colorWithRGBHex:PROFILE_COLOR].CGColor;
    drawView.layer.borderWidth=1.0f;
    drawView.layer.masksToBounds=YES;
    drawView.clipsToBounds=YES;
}
-(void)requestProfileDetails{
    [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
}
-(void) didGetProfileDetails:(NSMutableDictionary *) dataDictionaray
{
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dataDictionaray objectForKey:RESPONSE_ERROR]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATE object:responseDict];
            }
            else
            {
                NSLog(@"Database storage error");
            }
        }];
    }
}
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(NSString *)assignFriendName:(FriendsObject *)_friendObj{
    
    NSString *friendName;
    
    if (_friendObj.firstname.length>0) {
        if (_friendObj.lastname.length>0) {
            friendName=[NSString stringWithFormat:@"%@ %@",[[Context contextSharedManager] setFirstLetterCapital:_friendObj.firstname],[[Context contextSharedManager] setFirstLetterCapital:_friendObj.lastname]];
            return friendName;
        }
        friendName=[NSString stringWithFormat:@"%@",[[Context contextSharedManager] setFirstLetterCapital:_friendObj.lastname]];
    }else if(_friendObj.lastname.length>0){
        friendName=[NSString stringWithFormat:@"%@",[[Context contextSharedManager] setFirstLetterCapital:_friendObj.lastname]];
    }else if(_friendObj.username.length>0){
        friendName=[NSString stringWithFormat:@"%@",_friendObj.username];
    }else if(_friendObj.emailAddress.length>0){
        friendName=[NSString stringWithFormat:@"%@",_friendObj.emailAddress];
    }
    return friendName;
}

//Alert
-(void)showAlertView:(UIViewController *)controller withMessage:(NSString *)alertString withAlertTitle:(NSString *)alertTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}
//
//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
- (void) pgfetchDataForURL:(NSString *) url userInfo:(NSDictionary *) userInfo postTypeMethod:(int)methodType headerAutherization:(BOOL)iSheadReqAuth withCompletionHandler:(void (^)(NSDictionary *data, NSError *error))handler{
    
    if (_afOperation) {
        [_afOperation cancel];
    }
    NSString *requestMethod;
    NSString *userInfoKey;
    if(methodType == ePOST){
        requestMethod = @"POST";
        userInfoKey=@"postdata";
    }
    else if (methodType == eGET){
        requestMethod = @"GET";
        userInfoKey=@"parameters";
    }
    else if (methodType == ePUT)
        requestMethod = @"PUT";
    else if (methodType == eDeLETE)
        requestMethod = @"DELETE";
    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:url
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    request.userInfo = userInfo;
    request.timeoutInterval = 60.0;
    
    if ([userInfo objectForKey:userInfoKey] != nil)
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[userInfo objectForKey:userInfoKey] options:NSUTF8StringEncoding error:&error];
        [request setHTTPBody:(NSMutableData *)data];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if(iSheadReqAuth) {
        NSLog(@" Autherization Header required");
        NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
        [request setValue:[User_Profile getParameter:AUTH_VALUE] forHTTPHeaderField:@"Authorization" ];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    _afOperation=operation;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(responseObject)
         {
             handler(responseObject,nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         handler(nil,error);
     }];
    [manager.operationQueue addOperation:operation];
}
#pragma mark Clear UserDefaults

-(void)clearNSUserDefaults
{
    AppDelegate *appDg=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [appDg.persistentStoreCoordinator executeRequest:delete withContext:[appDg managedObjectContext] error:&deleteError];
}



@end
