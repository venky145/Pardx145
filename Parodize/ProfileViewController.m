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
#import "ProfileImageController.h"
#import "VerticalScrollView.h"
#import "iCarousel.h"
#import "CompletedModelClass.h"
#import "PendingObject.h"
#import "PendingUserObject.h"
#import "PendingView.h"

@interface ProfileViewController ()
{
    NSMutableDictionary *userDict;
    
    BOOL isOffset;
    
    FBSDKProfilePictureView *profilePictureview;
    
    NSDictionary *profileDict;
    
    CGRect pendingFrame;
    CGRect containerFrame;
    CGRect completedFrame;
    
    VerticalScrollView *scrollView;
    PendingView *pendingViewInfo;
    
    BOOL isPendingSelected;
    NSString *nextReqStr;
    
    NSMutableArray *completedArray;
    NSMutableArray *pendingArray;

    int reqCounterComplete;
    int reqCounterpending;
    
    BOOL isLoaded;
    
    //Completion images downloaded status
    BOOL isMockDone;
    BOOL isImageDone;
    
    NSInteger selectedIndex;
    
    NSString *fbShareUrl;
    BOOL isFbShare;
}

@end

@implementation ProfileViewController

@synthesize profileTableView,userProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetails:) name:PROFILE_UPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookShare:) name:@"facebookShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherShareAction:) name:@"shareAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftAction:) name:@"leftSwipe" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightAction:) name:@"rightSwipe" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visibleAction:) name:@"visibleAction" object:nil];
    
    self.profileImage.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImage addGestureRecognizer:singleTap];
    
    [self updateDetails:nil];
    
    nextReqStr=@"0";
    
    completedArray = [[NSMutableArray alloc]init];
    pendingArray = [[NSMutableArray alloc]init];
    _downButton.enabled=NO;
    
    _pendingCarousel.bounces = NO;
    _pendingCarousel.pagingEnabled = YES;
    _pendingCarousel.type = iCarouselTypeCustom;
    
    _completedCarousel.bounces = NO;
    _completedCarousel.pagingEnabled = YES;
    _completedCarousel.type = iCarouselTypeCustom;
    
    _pendingCarousel.hidden=YES;
    _completedCarousel.hidden=YES;
    
    [self requestPendingList];
    [self requestCompletedList];
    
    pendingFrame  = self.pendingView.frame;
    containerFrame = self.containerView.frame;
    completedFrame = self.completedView.frame;
}

-(void)profileTouched:(id)sender
{
    ProfileImageController *profileView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileImage"];
    
    profileView.profileData=self.profileImage.image;
    
    profileView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    
    [self presentViewController:profileView animated:NO completion:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)viewDidAppear:(BOOL)animated{
//    if (!isLoaded) {
//        isLoaded=YES;
//        pendingFrame  = self.pendingView.frame;
//        containerFrame = self.containerView.frame;
//        completedFrame = self.completedView.frame;
//    }
}
-(void)facebookShare:(NSNotification *)notification{
    
    //    [self showActivityWithMessage:nil];
    isFbShare=YES;
     [self shareAPI:YES];
    
}
- (UIImage*)imageByCombiningImage {
    //    UIImage *image = nil;
    
    UIImage *image1 = scrollView.originalImage.image;
    UIImage *image2 = scrollView.mockImage.image;
    
    CGSize size = CGSizeMake(image1.size.width*2+5, image1.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawInRect:CGRectMake(0,0,size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(image1.size.width+5,0,size.width, image2.size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //set finalImage to IBOulet UIImageView
    return finalImage;
}
- (UIImage *)margeSave{
    
    //here you get you two different image
    
    UIImage *bottomImage = scrollView.originalImage.image;
    UIImage *myImage       = scrollView.mockImage.image;
    
    //here  you have to crop each image with the code below
    //using here a crop code and adjust for your Image
    
    // create a new size for a merged image
    
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext( newSize );
    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [myImage drawInRect:CGRectMake(100,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    [self hideActivity];
    [self shareAPI:NO];
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    [self hideActivity];
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    [self hideActivity];
    NSLog(@"cancel");
    
}
-(void)shareAPI:(BOOL)isImage{
    
     [self showActivityWithMessage:nil];
    
    CompletedModelClass *completeModel=[completedArray objectAtIndex:self.completedCarousel.currentItemIndex];
    
    NSString *postID=completeModel.id;
    
    NSString *urlStr;
    
    if (isImage) {
        urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,COMBINE_IMAGE];
    }else{
         urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,SHARE_REQUEST];
    }
   
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:postID,@"id", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        if (error) {
            NSLog(@"%@",error.description);
        }else{
            NSLog(@"%@",data);
           
            
            if (!isImage) {
                [self hideActivity];
                 NSMutableDictionary *valueDict=[data valueForKey:RESPONSE_SUCCESS];
                [_scoreButton setTitle:[NSString stringWithFormat:@"%@",[valueDict objectForKey:@"score"]] forState:UIControlStateNormal];
                
                [User_Profile updateValue:@"score" withValue:[[valueDict objectForKey:@"score"] intValue]];
            }else{
                
                if ([data valueForKey:RESPONSE_ERROR]) {
                    [self hideActivity];
                    [[Context contextSharedManager] showAlertView:self withMessage:@"Something went wrong,Please try later" withAlertTitle:@"Failed"];
                }else{
                    
                    fbShareUrl=[data valueForKey:RESPONSE_SUCCESS];
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:fbShareUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                        if (image && finished) {
                            
                            // Cache image to disk or memory
                            
                            [self hideActivity];
                            
                            if (isFbShare) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                                    photo.image = image;
                                    photo.userGenerated = YES;
                                    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
                                    content.photos = @[photo];
                                    [FBSDKShareDialog showFromViewController:self
                                                                 withContent:content
                                                                    delegate:self];
                                });
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{

                                NSArray *activityItems = [NSArray arrayWithObjects:image, nil];
                                UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                                [self presentActivityController:activityController];
                                });
                            }
                        }
                    }];
                }
//                FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//                content.contentURL = [NSURL URLWithString:fbShareUrl];
//                
//                    [FBSDKShareDialog showFromViewController:self
//                                                 withContent:content
//                                                    delegate:self];
            }
           
        }
    }];
}
-(void)otherShareAction:(NSNotification *)notification{
   
    isFbShare=NO;
     [self shareAPI:YES];
}
-(void)leftAction:(NSNotification *)notification{
    if (isPendingSelected) {
        if (_pendingCarousel.currentItemIndex<pendingArray.count) {
            [_pendingCarousel scrollToItemAtIndex:_pendingCarousel.currentItemIndex+1 animated:YES];
        }
        
    }else{
        if (_completedCarousel.currentItemIndex<completedArray.count) {
            [_completedCarousel scrollToItemAtIndex:_completedCarousel.currentItemIndex+1 animated:YES];
        }

    }
}
-(void)rightAction:(NSNotification *)notification{
    if (isPendingSelected) {
        if (_pendingCarousel.currentItemIndex<pendingArray.count) {
            [_pendingCarousel scrollToItemAtIndex:_pendingCarousel.currentItemIndex-1 animated:YES];
        }
    }else{
        if (_completedCarousel.currentItemIndex<completedArray.count) {
            [_completedCarousel scrollToItemAtIndex:_completedCarousel.currentItemIndex-1 animated:YES];
        }
    }}

-(void)visibleAction:(NSNotification *)notification{
    
    CompletedModelClass *compModel=[completedArray objectAtIndex:self.completedCarousel.currentItemIndex];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,VISIBILITY];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:compModel.id,@"id",notification.object,@"isVisible",nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else{
            
             NSDictionary *successDict=[data objectForKey:@"success"];
            
            NSInteger visible = [[successDict objectForKey:@"isVisible"] longLongValue];
            
            
            compModel.isVisible = (int)visible;
            
        }
    }];
}
- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            [self shareAPI:NO];
        } else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
-(void)updateDetails:(id)sender
{
    userProfile=[User_Profile fetchDetailsFromDatabase:@"User_Profile"];
    
    [[Context contextSharedManager] roundImageView:self.profileImage withValue:self.profileImage.frame.size.height/2];
    
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
    
    [_scoreButton setTitle:[NSString stringWithFormat:@"%@",userProfile.score] forState:UIControlStateNormal];
    
           [self.navigationItem setTitle:[NSString stringWithFormat:@"@%@",userProfile.username]];
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:userProfile.profilePicture] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:userProfile.profilePicture] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%@",userProfile.score] forState:UIControlStateNormal];
    
    
}
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
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)editProfileAction:(id)sender {
    
    
}

//- (IBAction)logoutAction:(id)sender {
//    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    NSArray *viewControlles = self.navigationController.viewControllers;
//    
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    SplashViewController  *splachViewController= [storyBoard instantiateViewControllerWithIdentifier:@"SplashViewController"];
//    
//    for (int i = 0 ; i <viewControlles.count; i++){
//        if ([splachViewController isKindOfClass:[viewControlles objectAtIndex:i]]) {
//            //Execute your code
//            
//            [[self navigationController] popToViewController:splachViewController animated:YES];
//            
//            return;
//        }
//    }
//    
//    appDelegateTemp.window.rootViewController = splachViewController;
//    
//    [[Context contextSharedManager] deleteCoredataForEntity:USER_PROFILE];
//    
//    [self.revealViewController.view removeFromSuperview];
//    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        
//        [[FBSDKLoginManager new] logOut];
//        [FBSDKAccessToken setCurrentAccessToken:nil];
//    }
//    else
//    {
//        
//    }
//    
//}
#pragma mark UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return pendingArray.count;
    }else{
        return completedArray.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"pendingCell" forIndexPath:indexPath];
        
        PendingObject *pending=[pendingArray objectAtIndex:indexPath.row];
        
        
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:indexPath.row];
        UIImageView *imageV = [[UIImageView alloc]init];
        [imageV sd_setImageWithURL:[NSURL URLWithString:pending.recipientsGif] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        cell.backgroundView = imageV;
        [self.view addSubview:recipeImageView];
        
        cell.backgroundView.layer.cornerRadius=cell.frame.size.height/2;
        cell.backgroundView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.backgroundView.layer.borderWidth=0.5f;
        cell.backgroundView.layer.masksToBounds=YES;
        return cell;
        
        
    }else{
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"completedCell" forIndexPath:indexPath];
    
        CompletedModelClass *completeModel=[completedArray objectAtIndex:indexPath.row];
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:indexPath.row];
        UIImageView *imageV = [[UIImageView alloc]init];
        
        NSString *thumbStr=[completeModel.from objectForKey:@"thumbnail"];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:thumbStr ] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        
        cell.backgroundView = imageV;
        [self.view addSubview:recipeImageView];
        cell.backgroundView.layer.cornerRadius=cell.frame.size.height/2;
        cell.backgroundView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.backgroundView.layer.borderWidth=0.5f;
        cell.backgroundView.layer.masksToBounds=YES;
        return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    isMockDone=NO;
    isImageDone=NO;
    
    selectedIndex=indexPath.row;
    
    if (collectionView.tag==0) {
        isPendingSelected = YES;
       
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect getRect = self.pendingView.frame;
                             self.pendingView.frame = CGRectMake(0, 64,self.pendingView.frame.size.width,self.pendingView.frame.size.height+self.view.frame.size.width);
                             self.containerView.frame = CGRectMake(0, 0,self.containerView.frame.size.width,64);
                             pendingViewInfo=[[PendingView alloc]initWithFrame:CGRectMake(10, getRect.size.height, self.view.frame.size.width-20, self.view.frame.size.width+20)];
                             scrollView.isPending=YES;
                         }
                         completion:^(BOOL finished){
                             self.pendingView.translatesAutoresizingMaskIntoConstraints = YES;
                             self.pendingCarousel.translatesAutoresizingMaskIntoConstraints = YES;
                             self.containerView.translatesAutoresizingMaskIntoConstraints=YES;
                             self.completedView.hidden=YES;
                             _downButton.enabled=YES;
                             
                             [self.pendingView addSubview:pendingViewInfo];
                           
                             PendingObject *pendingModel=[pendingArray objectAtIndex:indexPath.row];
                             
                             //        scrollView.titleLabel.text=[completeModel.from objectForKey:@"firstname"];
                             [pendingViewInfo.originalImage sd_setImageWithURL:[NSURL URLWithString:pendingModel.challengeImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
                             pendingViewInfo.captionStr=pendingModel.caption;
                             
                             pendingViewInfo.pendingUserArray=pendingModel.from;
                             [pendingViewInfo setNeedsDisplay];
                         
                             _pendingCarousel.hidden=NO;
                             _pendingCollection.hidden=YES;
                             [_pendingCarousel scrollToItemAtIndex:indexPath.row animated:YES];
                         }];
    }else{
        isPendingSelected = NO;
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.completedView.frame = CGRectMake(0, 64,self.completedView.frame.size.width,self.completedView.frame.size.height+self.view.frame.size.width);
                             self.containerView.frame = CGRectMake(0, 0,self.containerView.frame.size.width,64);
                             self.pendingView.hidden=YES;
                             scrollView=[[VerticalScrollView alloc]initWithFrame:CGRectMake(10, pendingFrame.size.height, self.view.frame.size.width-20, self.view.frame.size.width)];
                             scrollView.isPending=NO;
                             
                         }
                         completion:^(BOOL finished){
                             self.completedView.translatesAutoresizingMaskIntoConstraints = YES;
                             self.completedCarousel.translatesAutoresizingMaskIntoConstraints = YES;
                             self.containerView.translatesAutoresizingMaskIntoConstraints=YES;
                             _downButton.enabled=YES;
                             
                             [self.completedView addSubview:scrollView];
                             //                         [self updateDetails:indexPath];
//                             scrollView.titleLabel.text=[NSString stringWithFormat:@"Venky %ld",(long)indexPath.row];
                             
                             CompletedModelClass *completeModel=[completedArray objectAtIndex:indexPath.row];

                             [scrollView.originalImage sd_setImageWithURL:[NSURL URLWithString:completeModel.challengeImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
                             
                             [scrollView.mockImage sd_setImageWithURL:[NSURL URLWithString:completeModel.responseImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
                            
                             scrollView.mockCaption.text=completeModel.responseCaption;
                             scrollView.originalCaption.text=completeModel.challengeCaption;
                             scrollView.titleLabel.text=[completeModel.from  objectForKey:@"firstname"];
                             
                             if (completeModel.isVisible == 1) {
                                 scrollView.visibleSwitch.on=YES;
                             }else{
                                 scrollView.visibleSwitch.on=NO;
                             }
                             
                             _completedCarousel.hidden=NO;
                             _completedCollection.hidden=YES;
                              [_completedCarousel scrollToItemAtIndex:indexPath.row animated:YES];
                         }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag==0) {
        if (indexPath.row==pendingArray.count-1) {
            
            //isLastIndex=YES;
            
            if (![nextReqStr isEqualToString:@"0"]&&nextReqStr !=nil) {
                
                if (reqCounterpending==2) {
                    
                    reqCounterpending=0;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self requestPendingList];
                    });
                }
                
            }
            
        }
    }else{
        if (indexPath.row==completedArray.count-1) {
            
            if (![nextReqStr isEqualToString:@"0"]&&nextReqStr !=nil) {
                
                if (reqCounterComplete==2) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        reqCounterComplete=0;
                        [self requestCompletedList];
                    });
                }
            }
        }
    }
    
}
#pragma mark - iCarousel



-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    if (carousel.tag==0) {

            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            
            view.layer.cornerRadius=25.0f;
        view.layer.borderColor=[UIColor lightGrayColor].CGColor;
        view.layer.borderWidth=0.5f;
        view.layer.masksToBounds=YES;

        PendingObject *pendingModel=[pendingArray objectAtIndex:index];
        
        [(UIImageView *)view sd_setImageWithURL:[NSURL URLWithString:pendingModel.recipientsGif] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        
        return view;
    }else{

            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            
            view.layer.cornerRadius=25.0f;
            view.layer.borderColor=[UIColor lightGrayColor].CGColor;
            view.layer.borderWidth=0.5f;
            view.layer.masksToBounds=YES;

        CompletedModelClass *completeModel=[completedArray objectAtIndex:index];
        
        [(UIImageView *)view sd_setImageWithURL:[NSURL URLWithString:[completeModel.from objectForKey:@"thumbnail"]] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        
        return view;
    }
}

//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
//    if (carousel.tag==0) {
//        [self showPendingDetail:index];
//    }else{
//        [self showCompletedDetails:index];
//    }
//   }
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
//    NSLog(@"Index: %@", @(self.iCarouselView.currentItemIndex));
    if (carousel.tag==0) {
        if (pendingArray.count>0) {
            [self showPendingDetail:self.pendingCarousel.currentItemIndex];
        }
        
    }else{
        if (completedArray.count>0) {
            [self showCompletedDetails:self.completedCarousel.currentItemIndex];
        }
        
    }
}
-(void)showPendingDetail:(NSInteger)index{

        PendingObject *pendingModel=[pendingArray objectAtIndex:index];
        
        //        scrollView.titleLabel.text=[completeModel.from objectForKey:@"firstname"];
        [pendingViewInfo.originalImage sd_setImageWithURL:[NSURL URLWithString:pendingModel.challengeImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        pendingViewInfo.pendingUserArray=pendingModel.from;
        pendingViewInfo.captionStr=pendingModel.caption;
        [pendingViewInfo setNeedsDisplay];
    
}
-(void)showCompletedDetails:(NSInteger)index{
    CompletedModelClass *completeModel=[completedArray objectAtIndex:index];
    
    scrollView.titleLabel.text=[completeModel.from objectForKey:@"firstname"];
    [scrollView.originalImage sd_setImageWithURL:[NSURL URLWithString:completeModel.challengeImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    [scrollView.mockImage sd_setImageWithURL:[NSURL URLWithString:completeModel.responseImage] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    scrollView.mockCaption.text=completeModel.responseCaption;
    scrollView.originalCaption.text=completeModel.challengeCaption;
    if (completeModel.isVisible == 1) {
        scrollView.visibleSwitch.on=YES;
    }else{
        scrollView.visibleSwitch.on=NO;
    }
    scrollView.titleLabel.text=[completeModel.from  objectForKey:@"firstname"];
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
        static CGFloat max_sacle = 1.0f;
        static CGFloat min_scale = 0.6f;
        if (offset <= 1 && offset >= -1) {
            float tempScale = offset < 0 ? 1+offset : 1-offset;
            float slope = (max_sacle - min_scale) / 1;
            
            CGFloat scale = min_scale + slope*tempScale;
            transform = CATransform3DScale(transform, scale, scale, 1);
        }else{
            transform = CATransform3DScale(transform, min_scale, min_scale, 1);
        }
        
        return CATransform3DTranslate(transform, offset * self.pendingCarousel.itemWidth * 1.4, 0.0, 0.0);

    
}
//- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel


-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    if (carousel.tag==0) {
        return pendingArray.count;
    }else{
        return completedArray.count;
    }
}


- (IBAction)downAction:(UIBarButtonItem *)sender {
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (isPendingSelected) {
                             self.pendingView.frame = pendingFrame;
                             self.containerView.frame = containerFrame;
                             _pendingCarousel.hidden=YES;
                             _pendingCollection.hidden=NO;
                             [pendingViewInfo removeFromSuperview];
 
                         }else{
                             self.completedView.frame = completedFrame;
                             self.containerView.frame = containerFrame;
                             _completedCarousel.hidden=YES;
                             _completedCollection.hidden=NO;
                             [scrollView removeFromSuperview];

                         }
                     }
                     completion:^(BOOL finished){
                          if (isPendingSelected) {
                              
                          }else{
                              
                          }
                         self.completedView.hidden=NO;
                         self.pendingView.hidden=NO;
                         _downButton.enabled=NO;
                         scrollView=nil;
                         pendingViewInfo=nil;
                     }];
    
    self.completedView.translatesAutoresizingMaskIntoConstraints = NO;
    self.completedCarousel.translatesAutoresizingMaskIntoConstraints = NO;
    self.pendingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pendingCarousel.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints=NO;
}

///// Completed

-(void)requestCompletedList{
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:nextReqStr,@"next", nil];
    
    [[DataManager sharedDataManager] requestCompletedChallenges:dict forSender:self];
    
}
#pragma DataManagerDelegate  Methods

-(void) didGetCompletedChallenges:(NSMutableDictionary *) dataDictionary {
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionary objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        
    }
    else
    {
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
        NSArray *compArray=[successDict objectForKey:@"challenge"];
        nextReqStr=[successDict objectForKey:@"next"];
        NSLog(@"Next-------%@",nextReqStr);

        
        if (compArray.count>0) {
            
            for(NSDictionary *arrDict in compArray)
            {
                CompletedModelClass *comp=[[CompletedModelClass alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    // NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([comp respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
//                            if ([key isEqualToString:@"visible"]) {
//                                NSLog(@"%@",[key isEqualToString:@"visible"]);
//                                [comp setValue:[arrDict valueForKey:key] forKey:@"visible"];
//                            }else{
                                 [comp setValue:[arrDict valueForKey:key] forKey:key];
//                            }
                            
                        }else
                            [comp setValue:@"" forKey:key];
                    }
                }
                
                [completedArray addObject:comp];
            }
            
            [self.completedCollection reloadData];
            
             [_completedCarousel reloadData];
            
            if (reqCounterComplete<2&&nextReqStr!=nil) {
                
                [self requestCompletedList];
                reqCounterComplete++;
            }
        }
    }
}
//Pending

-(void)requestPendingList{
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:nextReqStr,@"next", nil];
    
    [[DataManager sharedDataManager] requestPendingChallenges:dict forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void) didGetPendingChallenges:(NSMutableDictionary *) dataDictionary {
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);

    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionary objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        
    }
    else
    {
        
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
        NSArray *resultArray=[successDict objectForKey:@"pending"];
        
        nextReqStr=[successDict objectForKey:@"next"];
        
        if (resultArray.count>0) {
            for(NSDictionary *arrDict in resultArray)
            {
                PendingObject *pendindObj=[[PendingObject alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([pendindObj respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
                            if ([key isEqualToString:@"from"]){
                                ///
                                NSMutableArray *userArray=[[NSMutableArray alloc]init];
                                
                                NSArray *fromArray = [arrDict valueForKey:key];
                                for (NSDictionary *fromDict in fromArray) {
                                    PendingUserObject *userObj=[[PendingUserObject alloc]init];
                                    
                                        for (NSString *userKey in fromDict) {
                                            if ([userObj respondsToSelector:NSSelectorFromString(userKey)]) {
                                                if ([fromDict valueForKey:userKey] != NULL) {
                                                    [userObj setValue:[fromDict valueForKey:userKey] forKey:userKey];
                                                }else{
                                                    [userObj setValue:@"" forKey:userKey];
                                                }
                                            }
                                    }
                                   [userArray addObject:userObj];
                                }
                                 [pendindObj setValue:userArray forKey:key];
                              ///
                            }else
                                [pendindObj setValue:[arrDict valueForKey:key] forKey:key];
                        }else
                            [pendindObj setValue:@"" forKey:key];
                    }
                }
                
                [pendingArray addObject:pendindObj];
            }
            
            [self.pendingCollection reloadData];
            [_pendingCarousel reloadData];
            if (reqCounterpending<2&&nextReqStr!=nil) {
                
                [self requestPendingList];
                reqCounterpending++;
            }
        }
    }
}

-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
     [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
    
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [self downAction:nil];
//}

@end
