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


@interface FriendsViewController ()
{
    NSMutableArray *fbFriendsArray;
    UISearchBar *searchBarTop;
    UIBarButtonItem *searchBarItem;
    UIBarButtonItem *inviteBarItem;
    
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
    
   // https://graph.facebook.com/%@/picture?type=large
    
    searchBarTop=[[UISearchBar alloc]init];
    searchBarTop.showsCancelButton=YES;
    searchBarTop.delegate=self;
    searchBarTop.tintColor=[UIColor whiteColor];
    
    inviteBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriends:)];
    
    inviteBarItem.tintColor=[UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = inviteBarItem;

    
    searchBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarAction:)];
    
    searchBarItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchBarItem;
    
    self.friendsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getFriendDetails:nil];
}
-(void)getFriendDetails:(NSDictionary *)details{
    
    [self.processIndicator startAnimating];
    
    [[DataManager sharedDataManager] requestFriendsList:details forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void) didGetFriendsList:(NSMutableDictionary *) dataDictionaray{
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    [self.processIndicator stopAnimating];
    
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
        [fbFriendsArray removeAllObjects];
        
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        NSArray* getArray=[responseDict objectForKey:@"friends"];
        
        for (NSDictionary *fDict in getArray) {
            
            FriendsObject *fbObj=[[FriendsObject alloc]init];
            
            fbObj.firstname=[fDict objectForKey:@"firstname"];
            fbObj.lastname=[fDict objectForKey:@"lastname"];
            fbObj.f_id=[fDict objectForKey:@"id"];
            fbObj.thumbnail=[fDict objectForKey:@"thumbnail"];
            fbObj.emailAddress=[fDict objectForKey:@"email"];
            
            [fbFriendsArray addObject:fbObj];
        }
        
        [self.friendsTableView reloadData];
        
    }
    
    
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    [self.processIndicator stopAnimating];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        
    }
    else if(buttonIndex==1)
    {
        
    }
    
}
-(void)searchBarAction:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.titleView = searchBarTop;

}
-(void)inviteFriends:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"email",@"user_friends",@"public_profile",@"user_about_me"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self getFBFriendsList];
         }
     }];
}
#pragma mark UISearchBarDelegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.navigationItem.rightBarButtonItem = searchBarItem;
    self.navigationItem.leftBarButtonItem = inviteBarItem;
    self.navigationItem.titleView=nil;
    //self.navigationItem.title=@"Friends";
    

}// called when cancel button pressed
//-(void)viewWillAppear:(BOOL)animated
//{
//    if (fbFriendsArray.count==0)
//    {
//       // [self getFBFriendsList];
//    }
//}
-(void)getFBFriendsList
{
   /* FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends?limit=5000" parameters:nil HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        
        fbFriendsArray=[result objectForKey:@"data"];
        
        [friendsTableView reloadData];
        
        // Handle the result
        //        NSArray *items = [FBSDKUtility dictionaryWithQueryString:<#(NSString *)#> result[@"data"]];
        //        NSArray *recipientIDs = [items valueForKey:@"recipient_id"];
        //        _recipientIDs = [[NSSet alloc] initWithArray:recipientIDs];
        //        NSLog(@"%@",result[@"data"]);
    }];
    */
    
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fbFriendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"friendCell";
    
    FriendsCustomCell *cell=(FriendsCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    FriendsObject *fbObj=[fbFriendsArray objectAtIndex:indexPath.row];
    
   // NSDictionary *detailDict=[fbFriendsArray objectAtIndex:indexPath.row];
    cell.profileName.text=[NSString stringWithFormat:@"%@ %@",fbObj.firstname,fbObj.lastname];
//    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [detailDict objectForKey:@"id"]];
//    
//    
//    
//    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];

    
    if (fbObj.thumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:fbObj.thumbnail];
        cell.profileImage.image = [UIImage imageWithData:imageData];
    }else{
        cell.profileImage.image=[UIImage imageNamed:@"UserMale.png"];
    }
    
    
    //cell.profileName
    
    
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
        destViewController.friendObj = [fbFriendsArray objectAtIndex:path.row];
        
    }
}

@end
