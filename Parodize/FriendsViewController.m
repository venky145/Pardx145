//
//  FriendsViewController.m
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCustomCell.h"
#import "FriendsObject.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SDWebImage/UIImageView+WebCache.h"
#import "FriendDetailViewController.h"
#import "FriendRequestViewController.h"

#import "User_Profile.h"

@interface FriendsViewController ()
{
    NSMutableArray *fbFriendsArray;
    NSMutableArray *requestsArray;
    NSMutableArray *searchFriendsArray;
    UISearchBar *searchBarTop;
    UIBarButtonItem *searchBarItem;
    UIBarButtonItem *inviteBarItem;
   // UIBarButtonItem *requestBarItem;
    
    BOOL isSearch;
    
    AFHTTPRequestOperation *afOperation;
    
    UIRefreshControl *refreshControl;
    
    //NSArray *fbFriendsArray;
}

@end

@implementation FriendsViewController

@synthesize friendsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  self.title=@"Friends";
    
    fbFriendsArray=[[NSMutableArray alloc]init];
    searchFriendsArray=[[NSMutableArray alloc]init];
    requestsArray=[[NSMutableArray alloc]init];
    searchBarTop=[[UISearchBar alloc]init];
    searchBarTop.showsCancelButton=YES;
    searchBarTop.placeholder=@"Search friends";
    searchBarTop.delegate=self;
    searchBarTop.tintColor=[UIColor whiteColor];
    
    inviteBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriends:)];
    
    inviteBarItem.tintColor=[UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = inviteBarItem;

    
    searchBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarAction:)];
    
    searchBarItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchBarItem;

    self.friendsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(requestsList)
             forControlEvents:UIControlEventValueChanged];
    [self.friendsTableView setRefreshControl:refreshControl];
    
    [self requestsList];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
-(void)inviteFriends:(id)sender{
    
    if ([FBSDKAccessToken currentAccessToken]) {
         [self inviteInFacebook];
    }else{
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
                 [self inviteInFacebook];
             }
         }];
    }
    
}

-(void)inviteInFacebook{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://parodize.com"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.parodize.com"];
    
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    
}
-(void)requestsList{
    [self.processIndicator startAnimating];
    
    [[DataManager sharedDataManager] friendRequests:nil forSender:self];
}
-(void)getFriendDetails:(NSDictionary *)details{
    
    [[DataManager sharedDataManager] requestFriendsList:details forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void)didGetFriendRequests:(NSMutableDictionary *) dataDictionary{

    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
//        [self.processIndicator stopAnimating];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionary objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        [requestsArray removeAllObjects];
        
        NSMutableDictionary *responseDict=[[dataDictionary valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        NSArray* getArray=[responseDict objectForKey:@"friendRequests"];
        
        for (NSDictionary *fDict in getArray) {
        
            [requestsArray addObject:fDict];
        }
        
        NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"next", nil];
        [self getFriendDetails:dict];
        
    }
}

-(void) didGetFriendsList:(NSMutableDictionary *) dataDictionary{
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    
    [self.processIndicator stopAnimating];
    
    [refreshControl endRefreshing];
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionary objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        [fbFriendsArray removeAllObjects];
        NSMutableDictionary *responseDict=[[dataDictionary valueForKey:RESPONSE_SUCCESS] mutableCopy];
        NSArray* getArray=[responseDict objectForKey:@"friends"];
        for (NSDictionary *fDict in getArray) {
            FriendsObject *fbObj=[[FriendsObject alloc]init];
            fbObj.firstname=[fDict objectForKey:@"firstname"];
            fbObj.lastname=[fDict objectForKey:@"lastname"];
            fbObj.f_id=[fDict objectForKey:@"id"];
            fbObj.thumbnail=[fDict objectForKey:@"thumbnail"];
            fbObj.emailAddress=[fDict objectForKey:@"email"];
            fbObj.score=[fDict objectForKey:@"score"];
            fbObj.username=[fDict objectForKey:@"username"];
            
            [fbFriendsArray addObject:fbObj];
        }
        [self.friendsTableView reloadData];
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
//    [self.processIndicator stopAnimating];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server internal issue, unable to communicate " preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)searchBarAction:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.titleView = searchBarTop;
    isSearch=YES;
    [friendsTableView reloadData];
    
    [searchBarTop becomeFirstResponder];

}
#pragma mark UISearchBarDelegate methods
// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.navigationItem.rightBarButtonItem = searchBarItem;
    self.navigationItem.leftBarButtonItem = inviteBarItem;
    self.navigationItem.titleView=nil;
    //self.navigationItem.title=@"Friends";
    isSearch=NO;
    if (!afOperation.finished) {
        [afOperation cancel];
    }
    [self.friendsTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [afOperation cancel];

    [self SearchFriend:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}
-(void)SearchFriend:(NSString *)searchStr{
    
    NSMutableDictionary *searchDict=[[NSMutableDictionary alloc]init];
    [searchDict setValue:searchStr forKey:@"string"];

    NSString *requestMethod = @"POST";
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseAPI,SEARCH_FRIEND];
    
    
    NSError *error;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    __block NSMutableURLRequest *request = [manager.requestSerializer
                                            multipartFormRequestWithMethod:requestMethod
                                            URLString:requestURL
                                            parameters:nil
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            } error:&error];
    
    
    NSDictionary *jsonDict = @{
                               @"postdata": searchDict
                               };
    
    request.userInfo = jsonDict;
    
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
            // NSLog(@"%@",responseObject);
             
             if ([responseObject objectForKey:RESPONSE_ERROR]) {
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server request failed" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             }else
             {

                 NSDictionary *successDict=[responseObject objectForKey:@"success"];
                 
                 NSArray *resultArray=[successDict objectForKey:@"search"];
                 
                 [searchFriendsArray removeAllObjects];
                 
                 for (NSDictionary *fDict in resultArray) {
                     
                     FriendsObject *fbObj=[[FriendsObject alloc]init];
                     
                     fbObj.firstname=[fDict objectForKey:@"firstname"];
                     fbObj.lastname=[fDict objectForKey:@"lastname"];
                     fbObj.f_id=[fDict objectForKey:@"id"];
                     fbObj.thumbnail=[fDict objectForKey:@"thumbnail"];
                     fbObj.emailAddress=[fDict objectForKey:@"email"];
                     fbObj.score=[fDict objectForKey:@"score"];
                     
                     [searchFriendsArray addObject:fbObj];
                     
                 }
//                 dispatch_async(dispatch_get_main_queue(), ^{
                 
                     [self.friendsTableView reloadData];
//                 });
                 
                 
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",error);
         
         if (!operation.cancelled) {
             NSLog(@"Cancelled");
//             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//             
//             [alert show];
         }
     }];
    
    [manager.operationQueue addOperation:operation];
    
}
-(void)getFBFriendsList
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends?limit=5000" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         NSLog(@"%@",result);
         
         fbFriendsArray=[result objectForKey:@"data"];
         [friendsTableView reloadData];
     }];
    
    }
#pragma mark UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isSearch) {
        return 1;
    }else{
        
        if (requestsArray.count>0) {
            return 2;
        }else
            return 1;
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (!isSearch) {
        
        if (requestsArray.count>0) {
            if (section==0) {
                return @"Friend Requests";
            }else{
                
                return @"Friends";
            }
        }
    }

    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch) {
        return searchFriendsArray.count;
    }else{
        if (requestsArray.count>0) {
            if (section==0) {
                return 1;
            }else if (section==1){
                return fbFriendsArray.count;
            }
            
        }else{
            return fbFriendsArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        
       return [self MakeCellForTableView:tableView withData:searchFriendsArray withRow:indexPath];
        
    }else{
        if (requestsArray.count>0) {
            
            if (indexPath.section==0) {
               NSString* cellIdentifier=@"requestCell";
                
                UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (cell==nil)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                }
                
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)requestsArray.count];
                
                return cell;

                
            }else{
                 return [self MakeCellForTableView:tableView withData:fbFriendsArray withRow:indexPath];
            }
        }else{
            return [self MakeCellForTableView:tableView withData:fbFriendsArray withRow:indexPath];
        }
       // fbObj=[fbFriendsArray objectAtIndex:indexPath.row];
    }
   
    return nil;
}

-(UITableViewCell *)MakeCellForTableView:(UITableView *)tableView withData:(NSMutableArray *)dataArray withRow:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"friendCell";
    
    FriendsCustomCell *cell=(FriendsCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    FriendsObject *fbObj;
    fbObj=[dataArray objectAtIndex:indexPath.row];
    cell.profileName.text=[[Context contextSharedManager]assignFriendName:fbObj];
//    if (fbObj.thumbnail.length>0){
//        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:fbObj.thumbnail];
//        cell.profileImage.image = [UIImage imageWithData:imageData];
//    }else{
//        cell.profileImage.image=[UIImage imageNamed:@"UserMale.png"];
//    }
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:fbObj.thumbnail] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    if (fbObj.score == NULL) {
        cell.scoreLabel.text=[NSString stringWithFormat:@"-"];
    }else{
        cell.scoreLabel.text=[NSString stringWithFormat:@"%@",fbObj.score];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //  UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath]
    
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
    if ([segue.identifier isEqualToString:@"friendsDetail"]) {
        
         NSIndexPath *path = [self.friendsTableView indexPathForSelectedRow];
        
        FriendDetailViewController *destViewController = segue.destinationViewController;
        if (isSearch) {
            destViewController.friendObj = [searchFriendsArray objectAtIndex:path.row];
        }else{
            destViewController.friendObj = [fbFriendsArray objectAtIndex:path.row];
        }
        
        
    }else if ([segue.identifier isEqualToString:@"FRSegue"]){
        
        FriendRequestViewController *reqView=segue.destinationViewController;
        [reqView setRequestArray:requestsArray];
    }
}

@end
