//
//  FreindDetailViewController.m
//  Parodize
//
//  Created by Apple on 11/11/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "FriendDetailObject.h"
#import "User_Profile.h"

@interface FriendDetailViewController (){
    
    FriendDetailObject *fDetailObj;
}

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_friendObj.thumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:_friendObj.thumbnail];
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }else{
        self.profileImageView.image=[UIImage imageNamed:@"UserMale.png"];
    }

    [[Context contextSharedManager] roundImageView:self.profileImageView];
    
    self.friendName.text=[NSString stringWithFormat:@"%@ %@",[[Context contextSharedManager] setFirstLetterCapital:_friendObj.firstname],[[Context contextSharedManager] setFirstLetterCapital:_friendObj.lastname]];
    
    _addView.hidden=YES;
    _challengeView.hidden=YES;
 
    [self getFriendDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFriendDetails{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_friendObj.f_id,@"id", nil];
    [[DataManager sharedDataManager] friendsDetails:dict forSender:self];
}
-(void) didGetFriendDetails:(NSMutableDictionary *) dataDictionary{
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    
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
        
        NSDictionary* detailDict=[responseDict objectForKey:@"profile"];
        
        fDetailObj=[[FriendDetailObject alloc]init];
        
        for (NSString *key in detailDict) {
            
            NSLog(@"%@",[detailDict valueForKey:key]);
            
            if ([fDetailObj respondsToSelector:NSSelectorFromString(key)]) {
                
                if ([detailDict valueForKey:key] != NULL) {
                    [fDetailObj setValue:[detailDict valueForKey:key] forKey:key];
                }else
                    [fDetailObj setValue:@"" forKey:key];
            }
        }
        
        if (fDetailObj.about.length>0) {
            self.infoLabel.text=fDetailObj.about;
        }else{
            self.infoLabel.text=@"about yourself";
        }
        
        if (fDetailObj.isFriend == 2) {
            
            _addView.hidden=YES;
            _challengeView.hidden=NO;
            
        }else if (fDetailObj.isFriend == 1){
            [_addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
            _addFriendButton.enabled=NO;
            _addView.hidden=NO;
            _challengeView.hidden=YES;
        }else if (fDetailObj.isFriend == 0){
            [_addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
            _addView.hidden=NO;
            _challengeView.hidden=YES;
        }
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)followAction:(id)sender {
}

- (IBAction)challengeAction:(id)sender {
}

- (IBAction)addFriendAction:(id)sender {
    
    if (![_addFriendButton.titleLabel.text isEqualToString:@"Request Sent"]) {
    
    
    NSDictionary *detailDictV=[NSDictionary dictionaryWithObjectsAndKeys:fDetailObj.id,@"friend", nil];
    
    NSString *requestMethod =@"POST";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,NEW_FRIEND_REQUEST];
    
    
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
         if(responseObject)
         {
             // NSLog(@"%@",responseObject);
             
             if ([responseObject objectForKey:RESPONSE_ERROR]) {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                 
                 [alert show];
                 
             }else
             {
                 [_addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                 _addFriendButton.enabled=NO;
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Request failed");
         
         if (!operation.cancelled) {
             NSLog(@"Cancelled");
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
             
             [alert show];
         }
     }];
    
    [manager.operationQueue addOperation:operation];
    }
    
}
@end
