//
//  SignUpPageViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "SignUpPageViewController.h"
#import "ProfileImageViewController.h"
#import "Context.h"
#import "SignUpCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonParodize.h"
#import "SBJson.h"
#import "User_Profile.h"

@interface SignUpPageViewController ()
{

}

@end

@implementation SignUpPageViewController

@synthesize signUpButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    signUpButton.layer.cornerRadius=4.0f;

}
-(void)viewWillAppear:(BOOL)animated
{
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.emailTextField becomeFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    
    if (textField==self.emailTextField) {
        
        if ([[Context contextSharedManager] NSStringIsValidEmail:textField.text]) {
            
            NSLog(@"right email format");
            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
            
        }else{
            NSLog(@"Wrong email format");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email address" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        
            return NO;
        }
    }else if (textField == self.passwordTextField) {
        //[textField resignFirstResponder];
        if (textField.text.length==0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password should not be empty" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [textField resignFirstResponder];
            [self.confirmTextField becomeFirstResponder];
        }
    }else if (textField == self.confirmTextField) {
        //[textField resignFirstResponder];
        if (textField.text.length==0||![textField.text isEqualToString:self.passwordTextField.text]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password and confirm password doesn't match, Please check" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [textField resignFirstResponder];
            [self signupAction:nil];
        }
    }
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (IBAction)signupAction:(id)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    ProfileImageViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (self.emailTextField.text.length>0&self.passwordTextField.text.length>0&self.confirmTextField.text.length>0){
        if ([[Context contextSharedManager] NSStringIsValidEmail:self.emailTextField.text]) {
            if ([self.passwordTextField.text isEqualToString:self.confirmTextField.text]) {
                
                [self showActivityInView:self.view.superview withMessage:@""];
                NSDictionary* signupDict=[NSDictionary dictionaryWithObjectsAndKeys:self.emailTextField.text,@"email",self.confirmTextField.text,@"password", nil];
                
                [[DataManager sharedDataManager] registerEmailAccount:signupDict forSender:self];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password and confirm password doesn't match, Please check" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }else{
            NSLog(@"Wrong email format");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email address" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check all fields should not be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
     
    
}
#pragma TWDataManagerDelegate  Methods

-(void) didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
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
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *str1,NSString *str2,NSString *email) {
            if (flag) {
                
                //               //NSArray *userArray= [User_Profile fetchDetailsFromDatabase:@"User_Profile"];
                
                [[Context contextSharedManager] setLoginUser:YES forKey:EMAIL_LOGIN];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                ProfileImageViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
                [self.navigationController pushViewController:vc animated:YES];
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server internal issue, unable to communicate" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
//    
//    NSLog(@"%@",data);
//    
//    SBJsonParser *parser=[[SBJsonParser alloc]init];
//    
//    NSDictionary *dict=[parser objectWithData:data];
//    
//    if ([[dict allKeys]containsObject:@"errors"]) {
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[dict objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    }else{
//    
//        NSDictionary *authDict=[dict objectForKey:@"success"];
//        
//        NSLog(@"%@",[authDict objectForKey:@"auth"]);
//        
//        [[NSUserDefaults standardUserDefaults] setObject:[authDict objectForKey:@"auth"] forKey:@"Authorization"];
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        ProfileImageViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
//    
//    [self hideActivity];
//}
//
//// This method receives the error report in case of connection is not made to server.
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
//    
//    [self hideActivity];
//}
//
//// This method is used to process the data after connection has made successfully.
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSLog(@"Success");
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"signupSegue"]) {
        
        // ProfileImageViewController *profile=segue.destinationViewController;
        
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
