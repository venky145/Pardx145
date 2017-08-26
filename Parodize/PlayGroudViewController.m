//
//  SecondViewController.m
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "PlayGroudViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PGDetailViewController.h"
#import "PlayGroundCollectionViewCell.h"
#import "PlayGroundObject.h"
#import "PGResponseObject.h"
#import "NewCameraViewController.h"
#import "SearchTagsViewController.h"

@interface PlayGroudViewController ()
{
 //   SWRevealViewController *revealViewController;
    
    CLLocationManager *locationManager;
    
    float latitudeValue;
    float longitudeValue;
    
    NSString *nextStr;
    NSString *selfNextStr;
    
    NSMutableArray *pgArray;
    NSMutableArray *selfPGArray;
    
    BOOL isUpdate;
    UIRefreshControl *refreshControl;
    
    int distanceValue;
    
    BOOL isNext;
    BOOL isSelfNext;
    
    UITapGestureRecognizer *revealTap;
    NSIndexPath* selectedIndex;
    NSIndexPath* selfSelectedIndex;
    
    CGPoint _lastContentOffset;
}

@end

@implementation PlayGroudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  //  collectionView.hidden=YES;
    
    distanceValue = 10000;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(DistanceValueChanged:) name:@"NotificationMessageEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(tabBarStatus:) name:@"NotificationRevealedEvent" object:nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.panGestureRecognizer.enabled=YES;
    if ( revealViewController )
    {
        [self.distanceButton addTarget:self action: @selector( revealToggleBtn: ) forControlEvents:UIControlEventTouchUpInside];
       // [distanceButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    pgArray = [[NSMutableArray alloc]init];
    selfPGArray=[[NSMutableArray alloc]init];
    
    revealTap = [revealViewController tapGestureRecognizer];
    revealTap.delegate = self;
    [self.view addGestureRecognizer:revealTap];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.pdCollectionView setRefreshControl:refreshControl];
    
    self.pdCollectionView.allowsMultipleSelection=NO;
    self.pdCollectionView.allowsSelection=YES;
    
    _navView.layer.cornerRadius=5.0f;
    _navView.layer.masksToBounds=YES;
    
    _allButton.layer.cornerRadius=5.0f;
    _allButton.layer.masksToBounds=YES;
    
    _selfButton.layer.cornerRadius=5.0f;
    _selfButton.layer.masksToBounds=YES;
    
    _allButton.selected=YES;
    _allButton.backgroundColor=[UIColor whiteColor];
    _selfButton.selected=NO;

    isNext=NO;
    nextStr=@"0";
    selfNextStr=@"0";
    if (longitudeValue||latitudeValue) {
        [self showActivityWithMessage:nil];
        [self requestPlayGroundChallengesWithRadius:[NSString stringWithFormat:@"%d",distanceValue]];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
     [self.view removeGestureRecognizer:revealTap];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
    
   
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (!isUpdate) {
        isUpdate=YES;
        latitudeValue = locationManager.location.coordinate.latitude;
        longitudeValue = locationManager.location.coordinate.longitude;
        [self showActivityWithMessage:nil];
        [self requestPlayGroundChallengesWithRadius:[NSString stringWithFormat:@"%d",distanceValue]];
    }
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    latitudeValue = locationManager.location.coordinate.latitude;
    longitudeValue = locationManager.location.coordinate.longitude;
}
-(void)startRefresh:(id)sender{
    isNext=NO;
    nextStr=@"0";
    isSelfNext=NO;
    selfNextStr=@"0";
    if (_allButton.selected) {
        if (longitudeValue||latitudeValue) {
            [self requestPlayGroundChallengesWithRadius:[NSString stringWithFormat:@"%d",distanceValue]];
        }
    }else if (_selfButton.selected){
        [self requestSelfPosts];
    }
}
-(void)requestPlayGroundChallengesWithRadius:(NSString *)radiusStr{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_SCAN];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:radiusStr,@"radius",[NSString stringWithFormat:@"%f",latitudeValue],@"latitude",[NSString stringWithFormat:@"%f",longitudeValue],@"longitude",nextStr,@"next", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        NSLog(@"%@",data);
        
         [self hideActivity];
        
        [refreshControl endRefreshing];
        
        if ([data objectForKey:RESPONSE_ERROR]) {
        
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            if (!isNext) {
                [pgArray removeAllObjects];
            }
            
            NSDictionary *successDict=[data objectForKey:@"success"];
            
            NSArray *challengeArray = [successDict objectForKey:@"challenges"];
            
            if (challengeArray.count>0) {
            
                nextStr = [successDict objectForKey:@"next"];
                
                if (nextStr.length==0) {
                    nextStr = @"0";
                }
            
            for(NSDictionary *challengeDict in challengeArray){
                PlayGroundObject *pgObject = [[PlayGroundObject alloc]init];
        
                for (NSString *key in challengeDict) {
                    
                    // NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([pgObject respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([challengeDict valueForKey:key] != NULL) {
                        
                            [pgObject setValue:[challengeDict valueForKey:key] forKey:key];
                            }
                        else
                            [pgObject setValue:@"" forKey:key];
                        }
                    }
                
                 [pgArray addObject:pgObject];
                }
            
            }else{
                nextStr = @"0";
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdCollectionView reloadData];
            });
            
        }
    }];
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _lastContentOffset = scrollView.contentOffset;
//    NSLog(@"content %f",_lastContentOffset.y);
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    if (_lastContentOffset.x < (int)scrollView.contentOffset.x) {
//        NSLog(@"Scrolled Right");
//    }
//    else if (_lastContentOffset.x > (int)scrollView.contentOffset.x) {
//        NSLog(@"Scrolled Left");
//    }
//    
//    else if (_lastContentOffset.y < scrollView.contentOffset.y) {
//        NSLog(@"Scrolled Down");
//    }
//    
//    else if (_lastContentOffset.y > scrollView.contentOffset.y) {
//        NSLog(@"Scrolled Up");
//    }
//}
-(void)revealToggleBtn:(id)sender
{
    [self.revealViewController revealToggle:nil];
}
-(void)tabBarStatus:(NSNotification *)notification
{
    NSLog(@"%@",notification.object);
    
    if (notification.object==(id)kCFBooleanTrue)
    {
        NSLog(@"Revealed");
         self.tabBarController.tabBar.userInteractionEnabled = NO;
        [self.view addGestureRecognizer:revealTap];
    }
    else if(notification.object==(id)kCFBooleanFalse)
    {
        NSLog(@"Closed");
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        [self.view removeGestureRecognizer:revealTap];
    }
}
/*
- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:self.view.bounds];
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"s....%@",view);
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"se....%@",view);
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        
    }];
}
- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:self.view.bounds];
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"h....%@",view);
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                
                NSLog(@"he.....%@",view);
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
        
    }];
}
*/

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_selfButton.selected) {
        return selfPGArray.count;
    }else if (_allButton.selected){
        return pgArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_c cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellGrid";
    
    PlayGroundCollectionViewCell *cell =(PlayGroundCollectionViewCell *) [collectionView_c dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PlayGroundObject *pgObj;
    
    if (_selfButton.selected) {
        pgObj=[selfPGArray objectAtIndex:indexPath.row];
    }else if (_allButton.selected){
        pgObj=[pgArray objectAtIndex:indexPath.row];
    }
    
    [cell.pgImageView sd_setImageWithURL:[NSURL URLWithString:pgObj.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    
    cell.timeLabel.text=cell.timeLabel.text=[[Context contextSharedManager] setDateInterval:pgObj.time];
    cell.captionLabel.text=pgObj.caption;
    cell.distanceLabel.text=[NSString stringWithFormat:@"%ld km",(long)[pgObj.distance integerValue]];
    if (pgObj.responsesCount==0) {
       cell.countLabel.hidden=YES;
    }else{
        
        cell.countLabel.hidden=NO;
        cell.countLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)pgObj.responsesCount];
    }
    
    if (_allButton.selected) {
        if(indexPath.row == [pgArray count]-3){
            //Last cell was drawn
            if (![nextStr isEqualToString:@"0"]) {
                if (nextStr.length>0) {
                    isNext = YES;
                    [self requestPlayGroundChallengesWithRadius:[NSString stringWithFormat:@"%d",distanceValue]];
                }else{
                    nextStr = @"0";
                    isNext = NO;
                }
            }
        }
    }else if(_selfButton.selected){
        if(indexPath.row == [selfPGArray count]-3){
            //Last cell was drawn
            if (![selfNextStr isEqualToString:@"0"]) {
                if (selfNextStr.length>0) {
                    isSelfNext = YES;
                    [self requestSelfPosts];
                }else{
                    selfNextStr = @"0";
                    isSelfNext = NO;
                }
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_allButton.selected) {
         selectedIndex=indexPath;
    }else if(_selfButton.selected){
         selfSelectedIndex=indexPath;
    }
   
    [self performSegueWithIdentifier:@"pgDetailSegue" sender:self];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; //the spacing between cells is 2 px here
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth-15, cellWidth+45);
    
    return size;
}

-(void)DistanceValueChanged:(NSNotification *)notification
{
    UISlider *slider=(UISlider *) notification.object;
    
    NSLog(@"%d",10000-(int)roundf(slider.value));
    
    distanceValue=10000-(int)roundf(slider.value);
    
    [self.distanceButton setTitle:[NSString stringWithFormat:@"%d miles",distanceValue] forState:UIControlStateNormal];
    
    nextStr=@"0";
    isNext=NO;
    
    [self requestPlayGroundChallengesWithRadius:[NSString stringWithFormat:@"%d",distanceValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)challengeAction:(id)sender
{
    
//    [self performSegueWithIdentifier:@"PGDetail" sender:self];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewCameraViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCamera"];
    newViewController.isPlayGround=YES;
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    [self presentViewController:newNavigation animated:NO completion:nil];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pgDetailSegue"]) {
        
        PGDetailViewController *destViewController = segue.destinationViewController;
        if (_allButton.selected) {
            destViewController.isSelf=NO;
            destViewController.isFriends=NO;
            destViewController.pgObject=[pgArray objectAtIndex:selectedIndex.row];
        }else if(_selfButton.selected){
            destViewController.isSelf=YES;
            destViewController.isFriends=NO;
            destViewController.pgObject=[selfPGArray objectAtIndex:selfSelectedIndex.row];
        }
}
}
- (IBAction)upScrollAction:(id)sender {
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}
- (IBAction)downScrollAction:(id)sender {
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}



- (IBAction)searchAction:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SearchTagsViewController *searchViewController = [storyBoard instantiateViewControllerWithIdentifier:@"searchTag"];
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    [self presentViewController:newNavigation animated:NO completion:nil];
}
- (IBAction)allAction:(UIButton *)sender {
    if (sender.selected) {
        
    }else{
       
        _selfButton.selected=NO;
            sender.selected=YES;
        _selfButton.backgroundColor=[UIColor clearColor];
        _allButton.backgroundColor=[UIColor whiteColor];
        [self.pdCollectionView reloadData];
         self.pdCollectionView.scrollsToTop=YES;
    }
}

- (IBAction)selfAction:(UIButton *)sender {
    if (sender.selected) {
        
    }else{
        
        sender.selected=YES;
        _allButton.selected=NO;
        _allButton.backgroundColor=[UIColor clearColor];
        _selfButton.backgroundColor=[UIColor whiteColor];
        self.pdCollectionView.scrollsToTop=YES;
        if (selfPGArray.count==0) {
            [self requestSelfPosts];
        }else{
            [self.pdCollectionView reloadData];
        }
        
    }
}
-(void)requestSelfPosts{
    
    [self showActivityWithMessage:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_MYPOSTS];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:selfNextStr,@"next", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        [self hideActivity];
        
        [refreshControl endRefreshing];
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            if (!isSelfNext) {
                [selfPGArray removeAllObjects];
            }
            
            NSDictionary *successDict=[data objectForKey:@"success"];
            
            NSArray *challengeArray = [successDict objectForKey:@"challenges"];
            
            if (challengeArray.count>0) {
                
                selfNextStr = [successDict objectForKey:@"next"];
                
                if (selfNextStr.length==0) {
                    selfNextStr = @"0";
                }
                
                for(NSDictionary *challengeDict in challengeArray){
                    
                    PlayGroundObject *pgObject = [[PlayGroundObject alloc]init];
                    
                    for (NSString *key in challengeDict) {
                        
                        // NSLog(@"%@",[arrDict valueForKey:key]);
                        
                        if ([pgObject respondsToSelector:NSSelectorFromString(key)]) {
                            
                            if ([challengeDict valueForKey:key] != NULL) {

                                    [pgObject setValue:[challengeDict valueForKey:key] forKey:key];
                                }
                            else
                                [pgObject setValue:@"" forKey:key];
                            }
                        }
                    [selfPGArray addObject:pgObject];
                    
                }
            }else{
                selfNextStr = @"0";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdCollectionView reloadData];
            });
        }
    }];
}
@end
