//
//  SplashViewController.m
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "SplashViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import "SignUpViewController.h"
#import "SignUpViewController.h"
#import "User_Profile.h"
#import "HomeViewController.h"

@interface SplashViewController ()
{
    UIImageView *pdImage;
    BOOL side2Visible;
    NSMutableDictionary *fbDetails;
}
@end

@implementation SplashViewController

@synthesize fbButton,twtrButton,emailButton,loginView,userNameTextField,passwordTextField;
@synthesize passForgotButton,signInButton,signUpButton,closeButton,loginName,loginIndicatorView,appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabAction:) name:@"SuccessSignUp" object:nil];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    pdImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    
    //pdImage=[[UIImageView alloc]initWithFrame:CGRectMake(101, 117, 118, 118)];
    
    pdImage.center=self.view.center;
    
    [pdImage setImage:[UIImage imageNamed:@"Pd_Icon"]];
    
    pdImage.center = self.view.center;
    
    [self.view addSubview:pdImage];
    
    passwordTextField.hidden=YES;
    userNameTextField.hidden=YES;
    loginView.hidden=YES;
    passForgotButton.hidden=YES;
    signInButton.hidden=YES;
    signUpButton.hidden=YES;
    closeButton.hidden=YES;
    
    loginName.hidden=YES;
    loginIndicatorView.hidden=YES;
    
    [self roundedCorners:twtrButton];
    [self roundedCorners:emailButton];
    
    [self animateIcon];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
//    loginName.text=@"";
//    
//    loginName.hidden=YES;
//    loginIndicatorView.hidden=YES;
//    [loginIndicatorView stopAnimating];
//    
//    loginView.hidden=YES;
    
    

    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
//    if ([FBSDKAccessToken currentAccessToken]||[PFUser currentUser])
//    {
//        NSLog(@"already login");
//        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
//        tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:tabView animated:YES completion:nil];
//    }
//    else
//    {
 //        [self animateIcon];
 //   }
}
-(void)animateIcon {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myCallback:finished:context:)];
    
    CGRect frame = CGRectMake(pdImage.frame.origin.x, pdImage.frame.origin.y, 100, 100);
    frame.origin = CGPointMake(pdImage.frame.origin.x,44);
    pdImage.frame = frame;
    
    [UIView commitAnimations];
}

-(void)myCallback:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
//    CGRect frame = iconImageView.frame;
//    frame.origin = CGPointMake(0, 0);
//    iconImageView.frame = frame;
//    [self animateIcon];
    
   /* FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.readPermissions =@[@"email",@"user_birthday"];
    [self.view addSubview:loginButton];
    */
    
    //fbButton.readPermissions =@[@"email",@"user_friends",@"public_profile",@"user_about_me"];
//    if ([DataManager sharedDataManager].isLoggedUser) {
//        
//        loginView.hidden=YES;
//        loginIndicatorView.hidden=NO;
//        loginName.hidden=NO;
//        loginName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"fb_name"];
//        
//        [loginIndicatorView startAnimating];
//        
//    }else
//    {
        loginView.hidden=NO;
        loginIndicatorView.hidden=YES;
        loginName.hidden=YES;
        loginName.text=@"";
        
        [loginIndicatorView stopAnimating];
    //}
    
}

-(void)roundedCorners:(UIButton *)sender
{
    sender.layer.cornerRadius=2;
    sender.layer.masksToBounds=YES;
}
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error;
{
    
    if (error)
    {
        NSLog(@"%@",error);
    }
    else if (result.isCancelled)
    {
        NSLog(@"Cancelled");
    }
    else
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        
        
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             
             NSLog(@"%@",result[@"id"]);
             
             if (error)
             {
                 
             }
             else
             {
                 

             }
             
             //userDict=(NSMutableDictionary *)result;
             
         }];
    }
    
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
- (IBAction)tabAction:(id)sender
{
    loginView.hidden=YES;
    [self showActivityWithMessage:nil];
    [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
    
}
-(void)loginWithFirstName:(NSString *)firstName lastName:(NSString *)lastName forEmail:(NSString *)email
{
    [loginIndicatorView startAnimating];
    
    if (firstName.length>0) {
        if (lastName.length>0) {
            loginName.text=[NSString stringWithFormat:@"Login as %@ %@",firstName,lastName];
        }
        else
            loginName.text=[NSString stringWithFormat:@"Login as %@",firstName];
        
    }else
    {
        loginName.text=[NSString stringWithFormat:@"Login as %@",email];
    }
    
    
    
    loginName.hidden=NO;
    loginIndicatorView.hidden=NO;
    [loginIndicatorView startAnimating];
    
    loginView.hidden=YES;
    
   

}

- (IBAction)emailAction:(id)sender
{

        [UIView transitionWithView:loginView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ fbButton.hidden = YES; twtrButton.hidden = YES;emailButton.hidden=YES;passwordTextField.hidden=NO;userNameTextField.hidden=NO;passForgotButton.hidden=NO;signInButton.hidden=NO;signUpButton.hidden=NO; }
                        completion:^(BOOL finished){
                            if (finished) {
                                side2Visible=YES;
                                closeButton.hidden=NO;
                            }}];
    
}
- (IBAction)closeSignInAction:(id)sender
{
    [UIView transitionWithView:loginView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ fbButton.hidden = NO; twtrButton.hidden = NO;emailButton.hidden=NO;passwordTextField.hidden=YES;userNameTextField.hidden=YES;passForgotButton.hidden=YES;signInButton.hidden=YES;signUpButton.hidden=YES;closeButton.hidden=YES; }
                    completion:^(BOOL finished){
                        if (finished) {
                            side2Visible=NO;
                            closeButton.hidden=YES;
                        }}];
 
}

- (IBAction)signupAction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SignUpViewController *signUpVC = [storyBoard instantiateViewControllerWithIdentifier:@"signView"];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (IBAction)signInAction:(id)sender
{
    [self showActivityWithMessage:nil];
    
    if (userNameTextField.text.length>0 && passwordTextField.text.length>0)
    {
        NSDictionary *jsonDictionary=[[NSMutableDictionary alloc]init];
        
        //          [jsonDictionary setValue: @"shashank2" forKey:@"username"];
        [jsonDictionary setValue:userNameTextField.text forKey:@"email"];
        [jsonDictionary setValue:passwordTextField.text forKey:@"password"];
        [[DataManager sharedDataManager] loginAccount:jsonDictionary forSender:self];
        
    }
    else
    {
        
        [self hideActivity];
        
        UIAlertView *signErrorAlert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Please check Username/Email and Password shouldn't be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [signErrorAlert show];
    }
    
    
    
}
- (IBAction)forgotPassAction:(id)sender
{
    
    
}

- (IBAction)loginFaceBookAction:(id)sender {
    
    [self showActivityWithMessage:nil];
    
    NSArray *permissionsArray = @[ @"user_about_me",@"email", @"user_relationships", @"user_birthday", @"user_location",@"user_hometown",@"public_profile",@"user_friends"];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: permissionsArray
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
              [self hideActivity];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             
              [self hideActivity];
         } else {
             NSLog(@"Logged in");
             NSLog(@"%@",result);
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email, first_name, last_name, gender" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id results, NSError *error) {
                  NSLog(@"%@",results);
                  
                  
                  
                 // NSDictionary *resultDict=results;
                  
                   NSUserDefaults *sharedUserDefaults = [NSUserDefaults standardUserDefaults];
                  if (fbDetails.count>0) {
                      [fbDetails removeAllObjects];
                      fbDetails=nil;
                  }
                  
                  
                  
                  fbDetails=[[NSMutableDictionary alloc]init];
                  
                  [fbDetails setValue:[results objectForKey:@"first_name"] forKey:@"userFirstName"];
                  [fbDetails setValue:[results objectForKey:@"last_name"] forKey:@"userLastName"];
                  [fbDetails setValue:[results objectForKey:@"email"] forKey:@"userEmail"];
                  [fbDetails setValue:[results objectForKey:@"id"] forKey:@"userFbID"];
                  [fbDetails setValue:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[results objectForKey:@"id"]] forKey:@"profile_picture_URL"];
                 
                  [sharedUserDefaults setValue:fbDetails forKey:@"profile"];
                  [sharedUserDefaults setBool:YES forKey:@"fb_login"];
                  
                  NSString *tokenString=result.token.tokenString;
                  
                  
                  [self invokeCloudGetUserRegisteration:[NSDictionary dictionaryWithObjectsAndKeys:[results objectForKey:@"first_name"],@"firstname",[results objectForKey:@"last_name"],@"lastname",[results objectForKey:@"email"],@"email",[results objectForKey:@"id"],@"fbid",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[results objectForKey:@"id"]],@"profilePictureURL",tokenString,@"fb_accesstoken", nil]];
                  
              }];
             
         }
     }];
}
-(void)invokeCloudGetUserRegisteration:(NSDictionary *)profileDict {
    
    [[DataManager sharedDataManager] registerFacebookAccount:profileDict forSender:self];
}
#pragma mark DataManagerDelegate  Methods

-(void) didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        [self hideActivity];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dataDictionaray objectForKey:RESPONSE_ERROR]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
//        [self loginWithFirstName:[fbDetails objectForKey:@"userFirstName"] lastName:[fbDetails objectForKey:@"userLastName"] forEmail:[fbDetails objectForKey:@"userEmail"]];
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag) {
                
                //[self loginWithFirstName:firstName lastName:lastName forEmail:email];
                [appDelegate sendDeviceToken];
                
                [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
            }
            else
            {
                NSLog(@"Database storage error");
            }
        }];

        
        
    }
}

-(void) didLoggedIn:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        [self hideActivity];
        
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
                [[Context contextSharedManager] setLoginUser:YES forKey:EMAIL_LOGIN];
                
                [appDelegate sendDeviceToken];
                
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dataDictionary objectForKey:RESPONSE_ERROR]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        NSMutableDictionary *responseDict=[[dataDictionary valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag)
            {
                
                [self loginWithFirstName:firstName lastName:lastName forEmail:email];
                
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userNameTextField) {
        [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
    } else if (textField == passwordTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
