//
//  SignInViewController.m
//  Parodize
//
//  Created by Apple on 03/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpPageViewController.h"
#import "User_Profile.h"
#import "SWRevealViewController.h"


@interface SignInViewController ()
{
    
    BOOL isError;
    
}
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.signInButton.layer.cornerRadius=4.0f;
    self.signInButton.layer.masksToBounds=YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.userNameTextField becomeFirstResponder];
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

- (IBAction)signupAction:(id)sender
{
    
}

- (IBAction)signInAction:(id)sender
{
    [self showActivityInView:self.view.superview withMessage:nil];
    
    if (self.userNameTextField.text.length>0 && self.passwordTextField.text.length>0)
    {
        NSDictionary *jsonDictionary=[[NSMutableDictionary alloc]init];
        
        //          [jsonDictionary setValue: @"shashank2" forKey:@"username"];
        [jsonDictionary setValue:self.userNameTextField.text forKey:@"email"];
        [jsonDictionary setValue:self.passwordTextField.text forKey:@"password"];
        [[DataManager sharedDataManager] loginAccount:jsonDictionary forSender:self];
        
    }
    else
    {
        
        [self hideActivity];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Please check Email and Password shouldn't be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"Yes %@",textField);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.userNameTextField) {
        
        if ([[Context contextSharedManager] NSStringIsValidEmail:textField.text]) {
            
            NSLog(@"right email format");
            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
            
        }else{
            NSLog(@"Wrong email format");
            
            [self showErrorMessageWithString:@"Please enter valid email address"];
            
            return NO;
        }
    }else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self signInAction:nil];
    }
    
    return YES;
    
}
-(void)showErrorMessageWithString:(NSString *)errorString{
    
    if (!isError) {
        
        isError=YES;
        
        self.errorLabel.text=errorString;
        
           [self.userNameTextField becomeFirstResponder];
        
        self.errorView.hidden=NO;
        
        CGRect frameRect=self.errorView.frame;
        
        __block CGRect newRect = frameRect;
        
        [UIView transitionWithView:self.errorView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionNone
                        animations:^{
                            newRect.origin.y=0;
                            
                            self.errorView.frame=newRect;
                        }
                        completion:^(BOOL finished) {
                            
                            [NSTimer scheduledTimerWithTimeInterval:1.0 target:[NSBlockOperation blockOperationWithBlock:^{
                                
                                [UIView transitionWithView:self.errorView
                                                  duration:0.5
                                                   options:UIViewAnimationOptionTransitionNone
                                                animations:^{
                                                    
                                                    //newRect.origin.y=self.errorView.frame.size.height;
                                                    self.errorView.frame=frameRect;
                                                }
                                                completion:^(BOOL finished) {
                                                    
                                                    self.errorView.hidden=YES;
                                                    isError=NO;
                                                    
                                                }];
                                
                                
                            }] selector:@selector(main) userInfo:nil repeats:NO];
                        }];
    }
    
    
}

- (IBAction)forgotPassAction:(id)sender
{
    
    if (![[Context contextSharedManager] NSStringIsValidEmail:self.userNameTextField.text]||self.userNameTextField.text.length==0) {
        [self showErrorMessageWithString:@"Please enter valid email address"];
       // [self.userNameTextField becomeFirstResponder];
    }else{
        [self.passForgotButton setEnabled:NO];
        [self requestForgotPassword];
    }
}
-(void)requestForgotPassword{
    
    [self showActivityInView:self.view.superview withMessage:nil];
    
    NSDictionary *detailDictV=[NSDictionary dictionaryWithObjectsAndKeys:self.userNameTextField.text,@"email", nil];
    
    NSString *requestMethod =@"POST";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,RESET_PASSWORD];
    
    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:requestURL
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    NSDictionary *jsonDict = @{
                               @"postdata": detailDictV
                               };
    request.userInfo = jsonDict;
    
    if ([jsonDict objectForKey:@"postdata"] != nil)
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[jsonDict objectForKey:@"postdata"] options:NSUTF8StringEncoding error:&error];
        [request setHTTPBody:(NSMutableData *)data];
    }
    
    //request.timeoutInterval = 60.0;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@" Autherization Header required");
    NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
    [request setValue:[User_Profile getParameter:AUTH_VALUE] forHTTPHeaderField:@"Authorization" ];
    
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self.passForgotButton setEnabled:YES];
         
         if(responseObject)
         {
             
             if ([responseObject objectForKey:RESPONSE_ERROR]) {
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[responseObject objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             }else
             {
                 NSLog(@"%@",responseObject);
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Succes" message:[NSString stringWithFormat:@"Please check your mail %@ for password reset instructions",self.userNameTextField.text] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         
         [self.passForgotButton setEnabled:YES];
         
         if (!operation.cancelled) {
             NSLog(@"Cancelled");
            
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server request failed" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
    
    [manager.operationQueue addOperation:operation];
}
-(void) didLoggedIn:(NSMutableDictionary *) dataDictionaray {
    
    [self hideActivity];
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionaray objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        NSLog(@"%@",[responseDict objectForKey:@"score"]);
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag)
            {
                [[Context contextSharedManager] setLoginUser:YES forKey:EMAIL_LOGIN];
                
                [self.appDelegate sendDeviceToken];
                
                // [self loginWithFirstName:firstName lastName:lastName forEmail:email];
                [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
            }
            else
            {
                NSLog(@"Database storage error");
            }
        }];
        
    }
}

-(void) didGetProfileDetails:(NSMutableDictionary *) dataDictionary
{
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    
    [self hideActivity];
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionary objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        NSMutableDictionary *responseDict=[[dataDictionary valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        NSLog(@"%@",[responseDict objectForKey:@"score"]);
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag)
            {
            
                
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
                tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:tabView animated:YES completion:nil];
                
            }
            else
            {
                NSLog(@"Database storage error");
            }
        }];
        
    }
    
}

-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    [self hideActivity];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server internal issue, unable to communicate " preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
