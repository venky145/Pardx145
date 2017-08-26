//
//  NewDoneViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 21/12/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "NewDoneViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "User_Profile.h"
#import "AnimateCheckView.h"

@interface NewDoneViewController ()
{
    AppDelegate *appDelegate;
    UIVisualEffectView *bluredView;
    
    AFHTTPRequestOperation *afOperation;
    
    float latitudeValue;
    float longitudeValue;
}

@end

@implementation NewDoneViewController



@synthesize mockImageView,messageText,recipientIds,tagsStr,captionLabel,progressStatus,prgCancelButton,sendingLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",recipientIds);
    
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [mockImageView setImage:self.mockImage];
    
//    [mockImageView setImage:[[Context contextSharedManager] imageWithImage:self.mockImage scaledToSize:mockImageView.frame.size]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveToHome:)
                                                 name:@"checkAnimation"
                                               object:nil];
    
    sendingLabel.hidden=YES;
    progressStatus.hidden=YES;
    prgCancelButton.hidden=YES;
    if (_isPlayGround) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [locationManager startUpdatingLocation];
        latitudeValue = locationManager.location.coordinate.latitude;
        longitudeValue = locationManager.location.coordinate.longitude;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    
    messageText.layer.cornerRadius=4.0f;
    messageText.layer.masksToBounds=YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [messageText becomeFirstResponder];
}

- (IBAction)doneAction:(id)sender {
    
     [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    sendingLabel.hidden=NO;
    progressStatus.hidden=NO;
    prgCancelButton.hidden=NO;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:3.9];
    
    bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    bluredView.frame = self.view.bounds;
    
    [self.view addSubview:bluredView];
    
    [self.view bringSubviewToFront:progressStatus];
    
    [self.view bringSubviewToFront:prgCancelButton];
    
    [self.view bringSubviewToFront:sendingLabel];
    
    if (_isPlayGround||_isPGResponse) {
        [self postPlayGroundChallenge];
    }else{
         [self postNewChallenge];
    }
   
    
    
//       [pfImages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // The object has been saved.
//            NSLog(@"Successfully saved");
//        
//            [self doneWithSendingView];
//            
////            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
////            for (UIViewController *aViewController in allViewControllers) {
////                if ([aViewController isKindOfClass:[HomeViewController class]]) {
////                    [self.navigationController popToViewController:aViewController animated:NO];
////                }
////            }
//            
//            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
////            tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:tabView animated:YES completion:nil];
//            
//            
//        } else {
//            // There was a problem, check error.description
//            NSLog(@"Error: %@",error);
//        }
//    }
//     
//     
//     
//     ];
}
-(void)moveToHome:(NSNotification *)notificationCenter{
    [bluredView removeFromSuperview];
    bluredView=nil;
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
    //            tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:tabView animated:YES completion:nil];
}
-(void)showCheckMarkView{
    AnimateCheckView *animateView = [[AnimateCheckView alloc]initWithFrame:CGRectMake(self.view.center.x-25, self.view.center.y-25, 50, 50)];
    
    [self.view addSubview:animateView];
    [animateView setNeedsDisplay];
}

-(void)doneWithSendingView
{
    [progressStatus setProgress:0];
    sendingLabel.hidden=YES;
    progressStatus.hidden=YES;
    prgCancelButton.hidden=YES;
    sendingLabel.text=@"Sending . . .";
    
    [self showCheckMarkView];
}

- (IBAction)progressCancelAction:(id)sender {
    
    [afOperation cancel];

    [self doneWithSendingView];
    
}
- (IBAction)cancelAction:(id)sender {
    
     [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (void)keyboardWillShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);

    [UIView animateWithDuration:duration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        self.messageTextView.frame=CGRectMake(self.messageTextView.frame.origin.x, self.messageTextView.frame.origin.y-height, self.messageTextView.frame.size.width, self.messageTextView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{

    NSDictionary *info = [notification userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:duration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.messageTextView.frame=CGRectMake(self.messageTextView.frame.origin.x, self.messageTextView.frame.origin.y+height, self.messageTextView.frame.size.width, self.messageTextView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postPlayGroundChallenge{
    
    NSData *imageData = UIImageJPEGRepresentation(_mockImage, 1.0);
    NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
    NSMutableDictionary *detailDictV=[[NSMutableDictionary alloc]init];
    
    [detailDictV setValue:encodedString forKey:@"image"];
    [detailDictV setValue:messageText.text forKey:@"caption"];
    
    NSString *requestURL;
    if (_isPlayGround) {
        [detailDictV setValue:[NSString stringWithFormat:@"%f",latitudeValue] forKey:@"latitude"];
        
        [detailDictV setValue:[NSString stringWithFormat:@"%f",longitudeValue] forKey:@"longitude"];
        requestURL = [NSString stringWithFormat:@"%@%@", pgBASE_API,PG_NEW];
    }else if(_isPGResponse){
        [detailDictV setValue:appDelegate.pgrespObj.id forKey:@"id"];
        requestURL = [NSString stringWithFormat:@"%@%@", pgBASE_API,PG_RESPONSE];
    }

    
    [self sendRequest:detailDictV withApi:requestURL];
}

-(void)postNewChallenge
{
    NSData *imageData = UIImageJPEGRepresentation(_mockImage, 1.0);
    NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
    NSMutableDictionary *detailDictV=[[NSMutableDictionary alloc]init];
    
    [detailDictV setValue:encodedString forKey:@"image"];
    
    [detailDictV setValue:@"message" forKey:@"message"];
    
    [detailDictV setValue:messageText.text forKey:@"caption"];
    
    //    [detailDictV setValue:[NSArray arrayWithObject:@"12345"] forKey:@"recipients"];
    if (_isFriend) {
        [detailDictV setValue:[NSArray arrayWithObject:appDelegate.friendId] forKey:@"recipients"];

    }else{
        [detailDictV setValue:recipientIds forKey:@"recipients"];
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,NEW_CHALLENGE];
    [self sendRequest:detailDictV withApi:requestURL];
}
-(void)sendRequest:(NSDictionary *)dataDictionary withApi:(NSString *)apiStr{
    NSString *requestMethod = @"POST";
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:apiStr
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    NSDictionary *jsonDict = @{
                               @"postdata": dataDictionary
                               };
    
    request.userInfo = jsonDict;
    request.timeoutInterval = 60.0;

    if ([jsonDict objectForKey:@"postdata"] != nil)
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[jsonDict objectForKey:@"postdata"] options:NSUTF8StringEncoding error:&error];
        [request setHTTPBody:(NSMutableData *)data];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@" Autherization Header required");
    NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
    [request setValue:[User_Profile getParameter:AUTH_VALUE] forHTTPHeaderField:@"Authorization" ];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    afOperation=operation;
    // operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(responseObject)
         {
             NSLog(@"%@",responseObject);
             
             if ([responseObject objectForKey:RESPONSE_ERROR]) {
                 
                 [[Context contextSharedManager] showAlertView:self withMessage:[responseObject objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
                 
             }else
             {
                 NSMutableDictionary *valueDict=[responseObject valueForKey:RESPONSE_SUCCESS];
                  [User_Profile updateValue:@"score" withValue:[[valueDict objectForKey:@"score"] intValue]];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATE object:nil];
                 
                 
                 if (_isPlayGround||_isPGResponse) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_UPDATE object:valueDict];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }else{
                      [self doneWithSendingView];
                 }
                 
                 
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         
         [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
         
     }];
    
    
    
    [manager.operationQueue addOperation:operation];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progressStatus.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [self deregisterForKeyboardNotifications];
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [center removeObserver:self name:@"" object:nil];
}

@end
