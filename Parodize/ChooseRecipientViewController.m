//
//  ChooseRecipientViewController.m
//  Parodize
//
//  Created by administrator on 18/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "ChooseRecipientViewController.h"
#import "FriendsCustomCell.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SDWebImage/UIImageView+WebCache.h"

#import "NewDoneViewController.h"
#import "FriendsObject.h"

@interface ChooseRecipientViewController ()
{
    NSMutableArray *friendsArray;
    NSMutableArray *friendsIds;
    NSMutableArray *selectedIndexes;

}
@end

@implementation ChooseRecipientViewController
@synthesize recipientsTableView,tagsList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friendsArray=[[NSMutableArray alloc]init];
    friendsIds=[[NSMutableArray alloc]init];
    selectedIndexes=[[NSMutableArray alloc]init];
    
    self.recipientsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
//    imageview.image=_getImage;
//    imageview.backgroundColor=[UIColor redColor];
//    [self.view addSubview:imageview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    
    if (friendsArray.count==0)
    {
        [self getFriendDetails];
    }

}
-(void)getFriendDetails{
    
    [self.loadingIndicator startAnimating];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"next", nil];
    
    [[DataManager sharedDataManager] requestFriendsList:dict forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void) didGetFriendsList:(NSMutableDictionary *) dataDictionaray{
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    [self.loadingIndicator stopAnimating];
    
    [self hideActivity];
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionaray objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        
    }
    else
    {
        [friendsArray removeAllObjects];
        
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        NSArray* getArray=[responseDict objectForKey:@"friends"];
        
        for (NSDictionary *fDict in getArray) {
            
            FriendsObject *fbObj=[[FriendsObject alloc]init];
            
            fbObj.firstname=[fDict objectForKey:@"firstname"];
            fbObj.lastname=[fDict objectForKey:@"lastname"];
            fbObj.f_id=[fDict objectForKey:@"id"];
            fbObj.thumbnail=[fDict objectForKey:@"thumbnail"];
            fbObj.emailAddress=[fDict objectForKey:@"email"];
            fbObj.username=[fDict objectForKey:@"username"];
            
            [friendsArray addObject:fbObj];
        }
        
        [recipientsTableView reloadData];
        
    }
    
    
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    [self.loadingIndicator stopAnimating];
    
     [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
    
    
    
}
/*
-(void)getFBFriendsList
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends?limit=5000" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             NSLog(@"%@",result);
             
             friendsArray=[result objectForKey:@"data"];
             [recipientsTableView reloadData];
             
             [self getParodizeFriendsList];
         }];
        
    }else{
    
        [self getParodizeFriendsList];
    }
}

-(void)getParodizeFriendsList
{
    [[DataManager sharedDataManager] requestFriendsList:nil forSender:self];
}
-(void) didGetFriendsList:(NSMutableDictionary *) dataDictionaray
{
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
        
        
//        
//        [responseDict removeObjectForKey:@"notifications"];
//        
//        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
//            if (flag)
//            {
//                
//                [self loginWithFirstName:firstName lastName:lastName forEmail:email];
//                
//                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                SWRevealViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"reveal"];
//                tabView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//                [self presentViewController:tabView animated:YES completion:nil];
//                
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
*/



#pragma mark UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (friendsArray.count>0)
    {
        return friendsArray.count;
    }
    return 0;
    
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
    
    FriendsObject *fbObj=[friendsArray objectAtIndex:indexPath.row];

    cell.profileName.text=[[Context contextSharedManager]assignFriendName:fbObj];
    
     [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:fbObj.thumbnail] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath]
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        
        
        if ([selectedIndexes containsObject:indexPath]) {
            
            [selectedIndexes removeObject:indexPath];
        }
    }
    else
    {        
        [selectedIndexes addObject:indexPath];
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendAction:(id)sender
{
    for(NSIndexPath *indexPath in selectedIndexes)
    {
        FriendsObject *fbObj=[friendsArray objectAtIndex:indexPath.row];
        [friendsIds addObject:fbObj.f_id];
    }
    [self performSegueWithIdentifier:@"receipientSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
       if ([segue.identifier isEqualToString:@"receipientSegue"])
       {
        
        NewDoneViewController *destViewController = segue.destinationViewController;
        destViewController.recipientIds = friendsIds;
        destViewController.tagsStr=tagsList;
           destViewController.mockImage=self.getImage;
       }

}
@end
