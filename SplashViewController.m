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
#import "ProfileImageViewController.h"

@interface SplashViewController ()
{
//    UIImageView *pdImage;
    BOOL side2Visible;
    NSMutableDictionary *fbDetails;
    BOOL isError;
}
@end

@implementation SplashViewController

@synthesize fbButton,twtrButton,emailButton,loginName,loginIndicatorView,appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabAction:) name:@"SuccessSignUp" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabAction:) name:@"UserNameUpdate" object:nil];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    self.view.backgroundColor = [[Context contextSharedManager]
//                                 setBackgroundForView:self.view withImageName:@"pd_Background"];
    
    loginName.hidden=YES;
    loginIndicatorView.hidden=YES;

    loginName.hidden=YES;
    loginName.text=@"";
    
    [loginIndicatorView stopAnimating];
    
    [self roundedCorners:twtrButton];
    [self roundedCorners:emailButton];
    
//    [self animateIcon];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
 
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}
-(void)roundedCorners:(UIButton *)sender
{
    sender.layer.cornerRadius=2;
    sender.layer.masksToBounds=YES;
}
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error;
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
//    loginView.hidden=YES;
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
    
//    loginView.hidden=YES;
    
   

}

- (IBAction)emailAction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SignUpViewController *signUpVC = [storyBoard instantiateViewControllerWithIdentifier:@"SignInIdentifier"];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self presentViewController:navigationController animated:YES completion:nil];
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
                  
                  
                  [self invokeCloudGetUserRegisteration:[NSDictionary dictionaryWithObjectsAndKeys:[results objectForKey:@"first_name"],@"firstname",[results objectForKey:@"last_name"],@"lastname",[results objectForKey:@"email"],@"email",[results objectForKey:@"id"],@"fbid",[results objectForKey:@"gender"],@"gender",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[results objectForKey:@"id"]],@"profilePictureURL",tokenString,@"fb_accesstoken", nil]];
                  
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
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionaray objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        [responseDict removeObjectForKey:@"notifications"];
        
        NSString *userStr=[responseDict objectForKey:@"username"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
                if (flag) {
                    
                    if (userStr.length>0) {
                        //[self loginWithFirstName:firstName lastName:lastName forEmail:email];
                        [appDelegate sendDeviceToken];
                        
                        [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
                    }else{
                        [self hideActivity];
                        
                        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        ProfileImageViewController *profileView = [storyBoard instantiateViewControllerWithIdentifier:@"profilePage"];
                        profileView.isFacebookRegister=YES;
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileView];
                        // profileView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [self presentViewController:navigationController animated:YES completion:nil];
                    }
                    
                   
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server internal issue, unable to communicate " preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
