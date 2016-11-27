//
//  AcceptSendViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 10/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "AcceptSendViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "User_Profile.h"
#import "SWRevealViewController.h"

@interface AcceptSendViewController ()

{
    BOOL isKeypadShown;
    
    UIVisualEffectView *bluredView;
}

@end

@implementation AcceptSendViewController

@synthesize getImage,mockImage,originalImage,sendView,isAccept;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",getImage);
    if (getImage!=NULL)
    {
        [mockImage setImage:getImage];
    }
    
    if (self.getMockImage!=NULL) {
        [originalImage setImage:self.getMockImage];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.sendButton.layer.cornerRadius=5.0f;
    self.sendButton.layer.masksToBounds=YES;
    
    if (isAccept)
    {
        sendView.hidden=NO;
        self.title=@"Send";
    }
    else
    {
        sendView.hidden=YES;
        self.title=@"Completed";
    }
    
    self.progressStatus.hidden=YES;
    self.cancelButton.hidden=YES;
    
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    
    if (isKeypadShown)
    {
        isKeypadShown=YES;
        
        // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //Given size may not account for screen rotation
        int height = MIN(keyboardSize.height,keyboardSize.width);
        //    int width = MAX(keyboardSize.height,keyboardSize.width);
        
        //your other code here..........
        
        
        //    const int movementDistance = 260; // tweak as needed
        const float movementDuration = 0.35f; // tweak as needed
        
        //int movement = (up ? -height : height);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, -height);
        [UIView commitAnimations];

    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!isKeypadShown)
    {
        
        isKeypadShown=NO;
        // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //Given size may not account for screen rotation
        int height = MIN(keyboardSize.height,keyboardSize.width);
        //    int width = MAX(keyboardSize.height,keyboardSize.width);
        
        //your other code here..........
        
        
        //    const int movementDistance = 260; // tweak as needed
        const float movementDuration = 0.2f; // tweak as needed
        
        //int movement = (up ? -height : height);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, height);
        [UIView commitAnimations];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendAction:(id)sender {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.progressStatus.hidden=NO;
    self.cancelButton.hidden=NO;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:1.8];
    
    bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    bluredView.frame = self.view.bounds;
    
    [self.view addSubview:bluredView];
    
    [self.view bringSubviewToFront:self.progressStatus];
    
    [self.view bringSubviewToFront:self.cancelButton];

    NSMutableDictionary *acceptDict=[[NSMutableDictionary alloc]init];
    
    NSData *imageData = UIImageJPEGRepresentation(getImage, 1.0);
    NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];

    
    [acceptDict setValue:_acceptID forKey:@"id"];
    
    [acceptDict setValue:encodedString forKey:@"image"];
    
    [acceptDict setValue:@"caption_test" forKey:@"caption"];
    
    [acceptDict setValue:@"message_test" forKey:@"message"];
    
    
    //[[DataManager sharedDataManager] confirmAcceptChallenge:acceptDict forSender:self];
    
    [self completedAcceptChallenge:acceptDict];
}


- (IBAction)cancelAction:(id)sender {
    
    [self doneWithSendingView];
}
-(void)completedAcceptChallenge:(NSDictionary *)acceptDict
{
    NSString *requestMethod = @"POST";
    
    
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,ACCEPT_RESPONSE];
    
    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:requestURL
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    
    NSDictionary *jsonDict = @{
                               @"postdata": acceptDict
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
    // operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(responseObject)
         {
             NSLog(@"%@",responseObject);
             
             if ([responseObject objectForKey:@"error"]) {
                 
                 [self doneWithSendingView];
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                 
                 [alert show];
                 
             }else
             {
                 [self doneWithSendingView];
                 
                 UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                 SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
                 //            tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                 [self presentViewController:tabView animated:NO completion:nil];
                 
//                 NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//                 for (UIViewController *aViewController in allViewControllers) {
//                     if ([aViewController isKindOfClass:[RequiredViewController class]]) {
//                         [self.navigationController popToViewController:aViewController animated:NO];
//                     }
//                 }

                 
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
         
         [alert show];
         
     }];
    
    
    
    [manager.operationQueue addOperation:operation];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        self.progressStatus.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    
}

-(void)doneWithSendingView
{
    [self.progressStatus setProgress:0];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
   
    self.progressStatus.hidden=YES;
    self.cancelButton.hidden=YES;
    
    [bluredView removeFromSuperview];
    
    bluredView=nil;
    
}

@end
