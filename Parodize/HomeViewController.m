//
//  FirstViewController.m
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CamOverlayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ImageEditingViewController.h"
#import "AppDelegate.h"
#import "SplashViewController.h"
#import "SWRevealViewController.h"
#import "CompletedViewController.h"
#import "AcceptViewController.h"
#import "User_Profile.h"
#import "NewCameraViewController.h"
#import "SlideView.h"
#import "AcceptModelClass.h"
#import "AcceptParodizeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()
{
    UIImage  *mockImage;
    
    AppDelegate *appDelegate;
    
    UIImagePickerController *imagePicker;
    
    NSArray *colorArray;
    
    NSString *nextReqStr;
    
    BOOL isRefresh;
    BOOL isIgnore;
    
    CGRect slideCenter;
}
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *recentImage;
@end

@implementation HomeViewController

@synthesize userProfile,pr_Image;

- (void)viewDidLoad {
    [super viewDidLoad];
//    for (int i=1000; i<1050; i++) {
//       AudioServicesPlaySystemSound(i);
//    }
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
    self.challenges=[[NSMutableArray alloc]init];
    
     NSLog(@"Authorization Value = %@", [User_Profile getParameter:AUTH_VALUE]);
    
    int notifType=[Context contextSharedManager].pushType;
    
    if (notifType!=0) {
        
        [self pushNotificationReceived:notifType];
    }
    //configure carousel
    self.iCarouselView.type = iCarouselTypeRotary;
    self.iCarouselView.stopAtItemBoundary=YES;
//    self.iCarouselView.pagingEnabled=YES;
    self.iCarouselView.decelerationRate=0.8;
    
    _ignoreLabel.hidden=YES;
    
    colorArray=[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor magentaColor],[UIColor yellowColor], nil];
    
    nextReqStr=@"0";
    
    _challengeButton.hidden=YES;
    [self showActivityWithMessage:nil];
    [self requestAcceptedList];
}
-(void)pushNotificationReceived:(int)notify{
    
    if(notify!=0){        
        switch (notify) {
            case new_Challenge:
                
                break;
            case complete_Challenge:
                
                [self.tabBarController setSelectedIndex:2];
                
                break;
            case friend_Request:
                
                [self.tabBarController setSelectedIndex:2];
                
                break;
            case friend_Accept:
                
                [self.tabBarController setSelectedIndex:2];

                break;
                
            default:
                
                break;
        }
        
        [[Context contextSharedManager] setPushType:0];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{

}

-(void)profileImageTouched:(id)sender
{
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)newAction:(id)sender
{
    [self openNewPage];
}
-(void)openNewPage{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewCameraViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCamera"];
    newViewController.isPlayGround=NO;
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    [self presentViewController:newNavigation animated:NO completion:nil];
}

- (IBAction)logoutAction:(id)sender
{
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
    
    appDelegate.window.rootViewController = splachViewController;
    
    [self.revealViewController.view removeFromSuperview];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[FBSDKLoginManager new] logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else
    {
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editPhoto"]) {
        //[self.picker dismissViewControllerAnimated:NO completion:nil];

        ImageEditingViewController *imageViewController = segue.destinationViewController;
        imageViewController.getImage = mockImage;
    }
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    
    if (self.challenges.count>0) {
        return self.challenges.count;

    }else{
        return 1;
    }
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(SlideView *)view
{
    if (self.challenges.count>0) {
        
        view=[[[NSBundle mainBundle] loadNibNamed:@"SlideView" owner:self options:nil] objectAtIndex:0];
        view.contentMode = UIViewContentModeCenter;
        view.frame=CGRectMake(0, 0, self.view.frame.size.width-40, self.iCarouselView.frame.size.height);
        
//        UISwipeGestureRecognizer *swipeTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
// 
//        [swipeTop setDirection:UISwipeGestureRecognizerDirectionUp];
//        [view setUserInteractionEnabled:YES];
//        [view addGestureRecognizer:swipeTop];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        panRecognizer.delegate=self;
        [view addGestureRecognizer:panRecognizer];
        
        AcceptModelClass *acceptModel=[self.challenges objectAtIndex:index];
        
        NSDictionary *emailDict=acceptModel.from;
        
        if ([emailDict objectForKey:@"firstname"]) {
            if ([emailDict objectForKey:@"lastname"]) {
                view.subTitleLabel.text=[NSString stringWithFormat:@"%@ %@ has challenged you!",[emailDict objectForKey:@"firstname"],[emailDict objectForKey:@"lastname"]];
            }
            else
                view.subTitleLabel.text=[NSString stringWithFormat:@"%@ has challenged you!",[emailDict objectForKey:@"firstname"]];
        }else{
            
            NSString *emailStr=[emailDict objectForKey:@"email"];
            
            NSArray *stringArray=[emailStr componentsSeparatedByString:@"@"];
            
            view.subTitleLabel.text=[NSString stringWithFormat:@"%@ has challenged you!",[stringArray objectAtIndex:0]];
        }
        
        if (acceptModel.caption.length>0) {
            view.subTitleLabel.text=[NSString stringWithFormat:@"%@",acceptModel.caption];
        }else{
            view.subTitleLabel.text=[NSString stringWithFormat:CAPTION_STR];
        }
        
        view.titleLabel.text=[NSString stringWithFormat:@"%@ %@",[emailDict objectForKey:@"firstname"],[emailDict objectForKey:@"lastname"]];
        
        [view.slideProfileImage sd_setImageWithURL:[emailDict objectForKey:@"thumbnail"] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
        
        
        [view.slideContentImage sd_setImageWithURL:[NSURL URLWithString:acceptModel.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        
        view.timeLabel.text=[[Context contextSharedManager] setDateInterval:acceptModel.time];
        
        NSLog(@"........%@,%@",view.timeLabel.text,acceptModel.caption);
        
        return view;

    }else{
        view=[[SlideView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, self.iCarouselView.frame.size.height)];
        view.backgroundColor=[UIColor whiteColor];
        
        UIImageView *defaultImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width-60, self.iCarouselView.frame.size.height-60)];
        defaultImage.image = [UIImage imageNamed:@"defaultCard"];
        defaultImage.contentMode=UIViewContentModeScaleAspectFit;
        view.center= self.iCarouselView.center;
        [view addSubview:defaultImage];
        
        return view;
    }
    return view;
    
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 1.0;
        case iCarouselOptionWrap:
            return 0;
        default:
            return value;
    }
}
- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 1;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIActivityIndicatorView *indicatior = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, self.iCarouselView.frame.size.height)];
        indicatior = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
        indicatior.center=view.center;
        indicatior.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        indicatior.tag=1;
        [indicatior startAnimating];
        
//        label = [[UILabel alloc] initWithFrame:CGRectMake(indicatior.center.x-50, CGRectGetMaxY(indicatior.frame)+5, 100, 30)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [label.font fontWithSize:17.0];
//        label.tag = 2;
//        label.text=@"Loading";
//        [view addSubview:label];
        [view addSubview:indicatior];
    }
    else
    {
        //get a reference to the label in the recycled view
        indicatior = (UIActivityIndicatorView *)[view viewWithTag:1];
        label = (UILabel *)[view viewWithTag:2];
        
    }
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.iCarouselView.itemWidth);
}


#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %lu", (unsigned long)index);
    
    if (self.challenges.count>0) {
        
        AcceptModelClass *acceptModel=[self.challenges objectAtIndex:index];
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        AcceptParodizeViewController *acceptView = [storyBoard instantiateViewControllerWithIdentifier:@"acceptNav"];
        
        appDelegate.accpet_ID=acceptModel.id;
        if (acceptModel.thumbnail.length>0) {
            appDelegate.acceptImage=acceptModel.thumbnail;
        }
        
        appDelegate.acceptModel=acceptModel;
        
        [self presentViewController:acceptView animated:NO completion:nil];
        
    }else{
        
        [self openNewPage];
    }
    
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.iCarouselView.currentItemIndex));
    
    if (self.iCarouselView.currentItemIndex == self.challenges.count-2) {
        if (![nextReqStr isEqualToString:@"0"]&&nextReqStr.length) {
            [self requestAcceptedList];
        }
    }
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    if (carousel.scrollOffset<0) {
        if (!isRefresh&&!isIgnore) {
            isRefresh=YES;
            [self refreshList];
        }
    }
}
-(void)dragging:(UIPanGestureRecognizer *)gesture
{
    SlideView *slide =(SlideView *) self.iCarouselView.currentItemView;
    if (slideCenter.origin.y>0) {
        slideCenter = slide.frame;
    }
    
    CGPoint translation = [gesture translationInView:self.view];
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGPoint center = gesture.view.center;
    center.y += translation.y;
    if (center.y > self.view.center.y)
        return;
    slide.center = center;
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        if (center.y<0) {
            
                    [UIView animateWithDuration:0.3
                                          delay:0
                                        options: UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         CGRect editFrame = slide.frame;
                                         editFrame.origin.y= -self.view.frame.size.height;
            
                                         slide.frame=editFrame;
            
                                     }
                                     completion:^(BOOL finished){
            
                                         _ignoreLabel.hidden=NO;
                                         [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:1];
                                         slideCenter=CGRectMake(0, 0, 0, 0);
                                          [self ignoreChallenge];
                                     }];
        }else{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 CGRect editFrame = slide.frame;
                                 editFrame.origin.y= 0;
                                 editFrame.origin.x=0;
                                 
                                 slide.frame=editFrame;
                                 
                             }
                             completion:^(BOOL finished){
                                 
                                 _ignoreLabel.hidden=YES;
                                 slideCenter=CGRectMake(0, 0, 0, 0);
                             }];

        }
        NSLog(@"Ended");
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//ICarousel SlidesUp
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Down Swipe");
        
           }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Up Swipe");
        
        SlideView *slide =(SlideView *) self.iCarouselView.currentItemView;
        
        CGPoint translation = [swipe locationOfTouch:0 inView:self.view];
//        [swipe setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGPoint center = swipe.view.center;
        center.y += translation.y;
        if (center.y < self.view.center.y)
            return;
        slide.center = center;
        
//        CGPoint location = [swipe locationInView:self.view];
//        
//        SlideView *slide =(SlideView *) self.iCarouselView.currentItemView;
        
//        [UIView animateWithDuration:0.3
//                              delay:0
//                            options: UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             CGRect editFrame = slide.frame;
//                             editFrame.origin.y= -self.view.frame.size.height;
//                             
//                             slide.frame=editFrame;
//                             
//                         }
//                         completion:^(BOOL finished){
//                             
//                             _ignoreLabel.hidden=NO;
//                             [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:1];
//                              [self ignoreChallenge];
//                         }];
    }
}
-(void)ignoreChallenge{
    NSLog(@"%ld",(long)self.iCarouselView.currentItemIndex);
    AcceptModelClass *ignoreObject = [self.challenges objectAtIndex:self.iCarouselView.currentItemIndex];
    isIgnore = YES;
    if (self.iCarouselView.numberOfItems > 0)
    {
        NSInteger index = self.iCarouselView.currentItemIndex;
        [self.challenges removeObjectAtIndex:(NSUInteger)index];
        [self.iCarouselView removeItemAtIndex:index animated:YES];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,ACCEPT_IGNORE];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:ignoreObject.id,@"id",nil];

    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        isIgnore = NO;
        [self hideActivity];
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else{
            NSLog(@"ignore Succesfull");
            
            [self.iCarouselView  reloadData];
        }
    }];
}
-(void)hiddenLabel{
   _ignoreLabel.hidden=YES;
}
-(void)refreshList{
    nextReqStr=@"0";
    [self requestAcceptedList];
}
-(void)requestAcceptedList{
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:nextReqStr,@"next", nil];
    
    [[DataManager sharedDataManager] requestAcceptChallenges:dict forSender:self];
}

#pragma DataManagerDelegate  Methods

-(void) didGetAcceptedChallenges:(NSMutableDictionary *) dataDictionary {
    
    //NSLog(@"Yahooooo... \n %@",dataDictionary);
    [self hideActivity];
    
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionary objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
    }
    else
    {        
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
        NSArray *challengeArray=[successDict objectForKey:@"challenge"];
        
        nextReqStr=[successDict objectForKey:@"next"];
        NSLog(@"Next ...........%@",[successDict objectForKey:@"next"]);
        if (isRefresh||[nextReqStr isEqualToString:@"0"]) {
            if (isRefresh) {
                isRefresh = NO;
            }
            [self.challenges removeAllObjects];
        }
        
        if (challengeArray.count>0) {
            for(NSDictionary *arrDict in challengeArray)
            {
                AcceptModelClass *accept=[[AcceptModelClass alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    // NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([accept respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
                            
                        
                            [accept setValue:[arrDict valueForKey:key] forKey:key];
                        }else
                            [accept setValue:@"" forKey:key];
                    }
                }
                
                [self.challenges addObject:accept];
            }
            
            _challengeButton.hidden=NO;
            [self.iCarouselView reloadData];
        }else{
            _challengeButton.hidden=YES;
        }
        
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    [self hideActivity];
    
    [[Context contextSharedManager]showAlertView:self withMessage:SERVER_ERROR withAlertTitle:SERVER_ERROR];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
