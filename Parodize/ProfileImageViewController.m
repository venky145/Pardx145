//
//  ProfileImageViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "ProfileImageViewController.h"
#import "UserDetailViewController.h"
#import "Context.h"
#import <QuartzCore/QuartzCore.h>
#import "User_Profile.h"

@interface ProfileImageViewController ()
{
    NSMutableDictionary* jsonDictionary;
    
    BOOL isCheck;
    
    NSString *checkedStr;
}

@end

@implementation ProfileImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[Context contextSharedManager] colorWithRGBHex:UPPER_COLOR];
    
    self.checkButton.layer.cornerRadius=4.0f;
    
    self.warningLabel.hidden=YES;
    
    self.doneBarButton.enabled=NO;
    
    [self.usernameText addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
//    profileView.layer.cornerRadius=4.0f;
//    profileView.layer.borderWidth=1.0f;
//    profileView.layer.borderColor=[UIColor whiteColor].CGColor;
//    profileView.layer.masksToBounds=YES;
    
//    saveButton.enabled=NO;
//    saveButton.alpha=0.5;
    
}
-(void)textFieldDidChange:(NSNotification *)notify{
    
    NSLog(@"Notify ----- %@",self.usernameText.text);
    
    if (checkedStr.length>0) {
        
        if ([self.usernameText.text isEqualToString:checkedStr]) {
            
            _doneBarButton.enabled=YES;
        }else{
            _doneBarButton.enabled=NO;
            
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.usernameText becomeFirstResponder];
}

- (IBAction)checkAction:(id)sender{
    if (self.usernameText.text.length>5) {
        isCheck=false;
        [self requestUserNameAction];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"User name should contain more than 5 letters" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}
- (IBAction)doneAction:(id)sender {
    if (self.usernameText.text.length>5) {
         isCheck=true;
        [self requestUserNameAction];
    }
   
}
-(void)requestUserNameAction{
    
    [self showActivityInView:self.view.superview withMessage:@""];
    
    NSDictionary *detailDictV=[NSDictionary dictionaryWithObjectsAndKeys:self.usernameText.text,@"username",[NSNumber numberWithBool:isCheck],@"update",nil];
    
    NSString *requestMethod =@"POST";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,USER_NAME];
    
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
         [self hideActivity];
         
         if(responseObject)
         {
             // NSLog(@"%@",responseObject);
             
             if ([responseObject objectForKey:RESPONSE_ERROR]) {
                 if (isCheck==false) {
                     self.warningLabel.hidden=NO;
                     self.warningLabel.text=[NSString stringWithFormat:@"%@",[responseObject objectForKey:RESPONSE_ERROR]];
                     self.warningLabel.textColor=[UIColor redColor];
                     
                     self.doneBarButton.enabled=NO;

                 }else{
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[responseObject objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }else
             {
                 if (isCheck==false) {
                     self.warningLabel.hidden=NO;
                     self.warningLabel.text=[NSString stringWithFormat:@"\"%@\" is available",self.usernameText.text];
                     self.warningLabel.textColor=[UIColor blackColor];
                     self.doneBarButton.enabled=YES;
                     checkedStr=self.usernameText.text;

                 }else{
                  
                     if (_isFacebookRegister) {
                         [self dismissViewControllerAnimated:YES completion:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNameUpdate" object:jsonDictionary];
                         }];
                     }else{
                         [self performSegueWithIdentifier:@"userInfo" sender:self];
                     }
                 }
                
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         
         [self hideActivity];
         
         if (!operation.cancelled) {
             NSLog(@"Cancelled");
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server request" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
    
    [manager.operationQueue addOperation:operation];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        
        UserDetailViewController *userDetail=segue.destinationViewController;
        [userDetail setUsernameStr:self.usernameText.text];
        
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches began");
}


@end
