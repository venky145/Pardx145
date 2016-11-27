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
    NSArray *placeholderArray;
    NSArray *cellImageArray;
    
    NSIndexPath *nextIndexPath;
}

@end

@implementation SignUpPageViewController

@synthesize signupTableView,signUpButton,textDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    placeholderArray=[[NSMutableArray alloc]initWithObjects:@"Email",@"Password",@"Confirm Password", nil];
    cellImageArray=[[NSMutableArray alloc]initWithObjects:@"email_signup",@"password_signup",@"password_signup", nil];

    
    self.view.backgroundColor = [[Context contextSharedManager]
                                 setBackgroundForView:self.view withImageName:@"City-Blue.jpg"];
    
    
    signupTableView.layer.cornerRadius=4.0f;
    signUpButton.layer.cornerRadius=4.0f;
    
    textDict=[[NSMutableDictionary alloc]init];

}
-(void)viewWillAppear:(BOOL)animated
{
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SignUpCustomCell *cell = [signupTableView cellForRowAtIndexPath:indexPath];
    
    [cell.textField becomeFirstResponder];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row==0) {
//        return 154;
//    }
//    else
//    {
//        return 50;
//    }
//    
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignUpCustomCell *cell = (SignUpCustomCell*) [tableView dequeueReusableCellWithIdentifier:@"signUpCell"];
    
    if (cell==nil)
    {
        cell=[[SignUpCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"signUpCell"];
        
    }
    
    cell.textField.placeholder=[placeholderArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        
        cell.textField.secureTextEntry=NO;
        cell.textField.returnKeyType=UIReturnKeyNext;
    }
    else if (indexPath.row==1)
    {
        cell.textField.secureTextEntry=YES;
        cell.textField.returnKeyType=UIReturnKeyNext;
        
    }else if(indexPath.row==2) {
        cell.textField.secureTextEntry=YES;
        cell.textField.returnKeyType=UIReturnKeyDone;
    }
    
    
    cell.textField.tag=indexPath.row;
    
    [cell.logoImage setImage:[UIImage imageNamed:[cellImageArray objectAtIndex:indexPath.row]]];
    
    [textDict setObject:cell.textField forKey:[[placeholderArray objectAtIndex:indexPath.row] lowercaseString]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)validateAllTextFields
{
    for (NSString *key in placeholderArray) {
        UITextField *dataText=[textDict objectForKey:[key lowercaseString]];
        
        if (dataText.text.length==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"Please enter %@",key]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            return NO;
        }else if([[key lowercaseString] isEqualToString:@"email"]){
            
            NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
            
            if ([emailTest evaluateWithObject:dataText.text] != YES) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Please enter valid Email"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return NO;
            }
            
        }
    }
    
    return YES;
}
- (NSIndexPath *) nextIndexPath:(NSIndexPath *) indexPath {
    int numOfSections = 1;
    int nextSection = ((0 + 1) % numOfSections);
    
    if ((indexPath.row +1) == [self tableView:signupTableView numberOfRowsInSection:indexPath.section]) {
        return [NSIndexPath indexPathForRow:0 inSection:nextSection];
    } else {
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    SignUpCustomCell *currentCell = (SignUpCustomCell *) textField.superview.superview;
    NSIndexPath *currentIndexPath = [signupTableView indexPathForCell:currentCell];
    
    // NSIndexPath *currentIndexPath = [self.contactTableView indexPathForSelectedRow];
    if (currentIndexPath.row!=2) {
        
        nextIndexPath = [self nextIndexPath:currentIndexPath];
        SignUpCustomCell *nextCell = [signupTableView cellForRowAtIndexPath:nextIndexPath];
        
        [nextCell.textField becomeFirstResponder];
    }
    
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (IBAction)signupAction:(id)sender {
    
    if ([self validateAllTextFields]) {
        
        
        
        UITextField *passtext=[textDict objectForKey:@"password"];
        UITextField *confirmText=[textDict objectForKey:@"confirm password"];
        UITextField *emailText=[textDict objectForKey:@"email"];
        
        if ([passtext.text isEqualToString:confirmText.text])
        {
            
            [self showActivityInView:self.view.superview withMessage:@""];
            
           /* NSMutableDictionary* jsonDictionary=[[NSMutableDictionary alloc]init];
            
            //          [jsonDictionary setValue: @"shashank2" forKey:@"username"];
            [jsonDictionary setValue:confirmText.text forKey:@"password"];
            [jsonDictionary setValue:emailText.text forKey:@"email"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseAPI,SIGN_UP_API]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(conn) {
                NSLog(@"Connection Successful");
            } else {
                NSLog(@"Connection could not be made");
            }
            */
            
            NSDictionary* signupDict=[NSDictionary dictionaryWithObjectsAndKeys:emailText.text,@"email",confirmText.text,@"password", nil];
            
            [[DataManager sharedDataManager] registerEmailAccount:signupDict forSender:self];
            
        
        }else
        {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Password and confirm password doesn't match, Please check" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
        }
    }
}
#pragma TWDataManagerDelegate  Methods

-(void) didCloudGetUserRegisterationRequest:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    [self hideActivity];
    
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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

- (IBAction)cancelAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"signupSegue"]) {
        
        // ProfileImageViewController *profile=segue.destinationViewController;
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
