//
//  ProfileViewController.m
//  Parodize
//
//  Created by administrator on 10/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "ProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "EditProfileViewController.h"
#import "SplashViewController.h"
#import "SWRevealViewController.h"
@interface ProfileViewController ()
{
    NSMutableDictionary *userDict;
    
    BOOL isOffset;
    
    FBSDKProfilePictureView *profilePictureview;
    
    NSDictionary *profileDict;

}

@end

@implementation ProfileViewController

@synthesize profileTableView,userProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetails:) name:PROFILE_UPDATE object:nil];
    
    [self.navigationItem setTitle:@"Profile"];
    
    self.followView.hidden=YES;
    
    

    dispatch_async(dispatch_get_main_queue(), ^(){
        NSLog(@"A");
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSLog(@"B");
            
        });
        NSLog(@"C");
    });
    
    NSLog(@"D");
    
    [self updateDetails:userProfile];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //[[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)updateDetails:(id)sender
{
    userProfile=[User_Profile fetchDetailsFromDatabase:@"User_Profile"];
    
    [[Context contextSharedManager] roundImageView:self.profileImage];
    
//    if ([sender isKindOfClass:[NSNotification class]])   {
//        
//        NSNotification *noitifyInfo=(NSNotification *)sender;
//        
//        userProfile=noitifyInfo.object;
//    }
//    else if ([sender isKindOfClass:[User_Profile class]])   {
//        
//        userProfile=(User_Profile *)sender;
//        
//        
//    }
    
    if (userProfile.firstname.length>0) {
        if (userProfile.lastname.length>0) {
            self.profileName.text=[NSString stringWithFormat:@"%@ %@",userProfile.firstname,userProfile.lastname];
        }
        else
            self.profileName.text=[NSString stringWithFormat:@"%@",userProfile.firstname];
        
    }else
    {
        self.profileName.text=userProfile.email;
    }

    if (userProfile.about.length>0) {
        
        self.profileSubName.text=userProfile.about;
       // self.profileSubName.textColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
        
    }else
    {
        self.profileSubName.text=@"About yourself";
        self.profileSubName.textColor=[UIColor lightGrayColor];
    }
    
    if (userProfile.profilePicture.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:userProfile.profilePicture];
        self.profileImage.image = [UIImage imageWithData:imageData];
    }else{
        self.profileImage.image=[UIImage imageNamed:@"UserMale.png"];
    }
    
    
}
/*
#pragma mark UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"mockupCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 198;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath]
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,tableView.frame.size.width , 120)];
    
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Backgnd.png"]];
    
    UIImageView *profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 80, 80)];
    
    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
    profileImage.layer.masksToBounds=YES;
    
    UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(profileImage.frame), CGRectGetMaxY(profileImage.frame) + 5, profileImage.frame.size.width, 28)];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14.0f];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame)+5, CGRectGetMinY(profileImage.frame), CGRectGetMaxX(tableView.frame)-CGRectGetMaxX(profileImage.frame)-5-5, 42)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    UILabel *infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImage.frame)+5, CGRectGetMaxY(nameLabel.frame),nameLabel.frame.size.width, 21)];
    [infoLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    UIButton *logoutButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame)-95, CGRectGetMinY(scoreLabel.frame), 90, 21)];
    
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    //logoutButton.backgroundColor=[UIColor redColor];
    
    nameLabel.text=[userDict objectForKey:@"name"];
    infoLabel.text=[userDict objectForKey:@"email"];
    scoreLabel.text=@"(score)";
    scoreLabel.textAlignment=NSTextAlignmentCenter;
    
//    profilePictureview.frame=profileImage.frame;
//    
//    [profilePictureview setProfileID:[userDict objectForKey:@"id"]];
//    
//    [profileImage addSubview:profilePictureview];
    
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [userDict objectForKey:@"id"]];
    
    [profileImage sd_setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    
    
    [headerView addSubview:profileImage];
    [headerView addSubview:scoreLabel];
    [headerView addSubview:nameLabel];
    [headerView addSubview:infoLabel];
    [headerView addSubview:logoutButton];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier=@"detailCell";
    
    UITableViewCell  *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"First Name";
        cell.detailTextLabel.text=[userDict objectForKey:@"first_name"];
        
        NSLog(@"----%@",cell.detailTextLabel.text);
        
    }else if (indexPath.row==1) {
        cell.textLabel.text=@"Last Name";
        cell.detailTextLabel.text=[userDict objectForKey:@"last_name"];
        
    }else if (indexPath.row==2) {
        cell.textLabel.text=@"About";
        cell.detailTextLabel.text=@"Write something";
        
    }
   
    
    return cell;
    
}


/*- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scroll.contentOffset.y;
    //CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    // Change 10.0 to adjust the distance from bottom
    if (currentOffset > 59) {
        
        if (!isOffset)
        {
            isOffset=YES;
            leftBtn.hidden=NO;
            [self.navigationItem setTitle:[userDict objectForKey:@"name"]];
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [userDict objectForKey:@"id"]];
            
//            profilePictureview .frame=CGRectMake(0, 0, leftBtn.frame.size.width, leftBtn.frame.size.height);
//            [profilePictureview setProfileID:[userDict objectForKey:@"id"]];
//            [leftBtn addSubview:profilePictureview];
            
           // UIImageView *view = (UIImageView *)profilePictureview;
            
           // [leftBtn setImage:[self profilePicture] forState:UIControlStateNormal];
            
            [leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:userImageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
            
            leftBtn.layer.cornerRadius=leftBtn.frame.size.height/2;
            leftBtn.layer.masksToBounds=YES;
        }
    }
    else
    {
        if (isOffset)
        {
            isOffset=NO;
            leftBtn.hidden=YES;
            [self.navigationItem setTitle:@"Profile"];
        }
    }
}
 */
-(UIImage *)profilePicture
{
   // __block UIImage *image = nil;
    
//    [profilePictureview.subviews enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isMemberOfClass:[UIImageView class]]) {
//            UIImageView *objImg = (UIImageView *)obj;
//            image = objImg.image;
//            *stop = YES;
//        }
//    }];
    
    UIImage *image = nil;
    
    for (NSObject *obj in [profilePictureview subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            image = objImg.image;
            break;
        }
    }
    
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editProfile"]) {
        
        EditProfileViewController *destViewController = segue.destinationViewController;
        destViewController.getImage = self.profileImage.image;
        destViewController.editUserProfile=userProfile;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)followAction:(id)sender {
    
    self.followView.hidden=YES;
    self.logoutView.hidden=NO;
    
}
- (IBAction)editProfileAction:(id)sender {
    
    
}

- (IBAction)logoutAction:(id)sender {
    
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SplashViewController  *splachViewController= [storyBoard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    
    for (int i = 0 ; i <viewControlles.count; i++){
        if ([splachViewController isKindOfClass:[viewControlles objectAtIndex:i]]) {
            //Execute your code
            
            [[self navigationController] popToViewController:splachViewController animated:YES];
            
            return;
        }
    }
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    appDelegateTemp.window.rootViewController = splachViewController;
    
    [[Context contextSharedManager] deleteCoredataForEntity:USER_PROFILE];
    
    [self.revealViewController.view removeFromSuperview];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[FBSDKLoginManager new] logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else
    {
        
    }
    
}
@end
