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

@interface NewDoneViewController ()
{
    AppDelegate *appDelegate;
    UIVisualEffectView *bluredView;
    
    AFHTTPRequestOperation *afOperation;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    sendingLabel.hidden=YES;
    progressStatus.hidden=YES;
    prgCancelButton.hidden=YES;
    
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
    
    [self postNewChallenge];
    
    
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

-(void)doneWithSendingView
{
    [progressStatus setProgress:0];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    sendingLabel.hidden=YES;
    progressStatus.hidden=YES;
    prgCancelButton.hidden=YES;
    
    [bluredView removeFromSuperview];
    
    bluredView=nil;
    
    sendingLabel.text=@"Sending . . .";
    
}

- (IBAction)progressCancelAction:(id)sender {
    
    [self doneWithSendingView];
    
    [afOperation cancel];
}
- (IBAction)cancelAction:(id)sender {
    
     [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (void)keyboardWillShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    //    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    
    
    //    const int movementDistance = 260; // tweak as needed
    const float movementDuration = 0.30f; // tweak as needed
    
    //int movement = (up ? -height : height);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, -height);
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postNewChallenge
{

    NSData *imageData = UIImageJPEGRepresentation(_mockImage, 1.0);
    NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
    
    NSString *capString=tagsStr;
    
    NSString *requestMethod = @"POST";
    
    
    
     NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,NEW_CHALLENGE];

    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:requestURL
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    NSMutableDictionary *detailDictV=[[NSMutableDictionary alloc]init];
    
    [detailDictV setValue:encodedString forKey:@"image"];
    
    [detailDictV setValue:@"message" forKey:@"message"];
    
    [detailDictV setValue:messageText.text forKey:@"caption"];
    
//    [detailDictV setValue:[NSArray arrayWithObject:@"12345"] forKey:@"recipients"];
    
    [detailDictV setValue:recipientIds forKey:@"recipients"];
    
    //    [NSDictionary dictionaryWithObjectsAndKeys:encodedString,@"image",capString,@"caption",messageText.text,@"message",recipientIds,@"recipients", nil];
    
    NSDictionary *jsonDict = @{
                               @"postdata": detailDictV
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
             
             if ([responseObject objectForKey:@"error"]) {
                 
                 [self doneWithSendingView];
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                 
                 [alert show];
                 
             }else
             {
                 [self doneWithSendingView];
                 
                 //NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                 //            for (UIViewController *aViewController in allViewControllers) {
                 //                if ([aViewController isKindOfClass:[HomeViewController class]]) {
                 //                    [self.navigationController popToViewController:aViewController animated:NO];
                 //                }
                 //            }
                 
                             UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                             SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
                 //            tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                             [self presentViewController:tabView animated:YES completion:nil];
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
        progressStatus.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    
}


@end
