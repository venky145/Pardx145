//
//  UserDetailViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "UserDetailViewController.h"
#import "Context.h"
#import <QuartzCore/QuartzCore.h>
#import "User_Profile.h"


@interface UserDetailViewController ()
{
    NSMutableDictionary* jsonDictionary;
}

@end

@implementation UserDetailViewController
@synthesize profileImage,firstName,lastName,aboutMe,saveButton,savedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[Context contextSharedManager]
                                 setBackgroundForView:self.view withImageName:@"City-Blue.jpg"];
    

    
    firstName.layer.cornerRadius=2.0f;
    lastName.layer.cornerRadius=2.0f;
    aboutMe.layer.cornerRadius=2.0f;
    saveButton.layer.cornerRadius=2.0f;
    
    profileImage.layer.cornerRadius=4.0f;
    profileImage.layer.borderWidth=1.0f;
    profileImage.layer.borderColor=[UIColor whiteColor].CGColor;
    profileImage.layer.masksToBounds=YES;
    
    if (savedImage) {
        profileImage.image=savedImage;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [firstName becomeFirstResponder];
    
}


- (IBAction)saveAction:(id)sender {
    
    [self showActivityInView:self.view.superview withMessage:@""];
    
    jsonDictionary=[[NSMutableDictionary alloc]init];
    
    //          [jsonDictionary setValue: @"shashank2" forKey:@"username"];
    [jsonDictionary setValue:firstName.text forKey:@"firstname"];
    [jsonDictionary setValue:lastName.text forKey:@"lastname"];
    [jsonDictionary setValue:aboutMe.text forKey:@"about"];
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:nil];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseAPI,INFORMATION_API]]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"] forHTTPHeaderField:@"Authorization"];
//    [request setHTTPBody:jsonData];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if(conn) {
//        NSLog(@"Connection Successful");
//    } else {
//        NSLog(@"Connection could not be made");
//        [self hideActivity];
//    }
    
    
    [[DataManager sharedDataManager] updateInformation:jsonDictionary forSender:self];
}
#pragma TWDataManagerDelegate  Methods

-(void) didInformationUpdated:(NSMutableDictionary *) dataDictionaray; {
    
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
        
//        [User_Profile saveUserProfile:jsonDictionary withCompletionBlock:^(BOOL flag) {
//            if (flag)
//            {
        [self skipAction:nil];

//            }
//            else
//            {
//                NSLog(@"Database storage error");
//            }
//        }];
//        
        
        
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
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessSignUp" object:dict];
//        }];
//        
////        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
////        ProfileImageViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
////        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
//    
//    [self hideActivity];
//}
//
//// This method receives the error report in case of connection is not made to server.
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
//    [self hideActivity];
//}
//
//// This method is used to process the data after connection has made successfully.
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSLog(@"Success");
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    int limit = 100;
    return !([textField.text length]>limit && [string length] > range.length);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == firstName) {
        [textField resignFirstResponder];
        [lastName becomeFirstResponder];
    } else if (textField == lastName) {
        [textField resignFirstResponder];
        [aboutMe becomeFirstResponder];
    }else if (textField == aboutMe) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

- (IBAction)skipAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessSignUp" object:jsonDictionary];
    }];
}
@end
