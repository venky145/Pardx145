//
//  PGDetailViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 19/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "PGDetailViewController.h"
#import "ResponseView.h"
#import "PGResponseObject.h"
#import "NewCameraViewController.h"
#import "AppDelegate.h"
#import "PGResponseObject.h"

@interface PGDetailViewController ()
{
    BOOL isViewLoaded;
    NSString *nextStr;
    NSMutableArray *responsesArray;
    UIBarButtonItem *rightButton;
}

@end

@implementation PGDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.icarouselView.type = iCarouselTypeRotary;
    self.icarouselView.stopAtItemBoundary=YES;
    self.icarouselView.decelerationRate=0.8;
    
    responsesArray= [[NSMutableArray alloc]init];
    
    [self.challengeImageView sd_setImageWithURL:[NSURL URLWithString:_pgObject.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    if (_pgObject.caption.length>0){
        self.captionLabel.text=_pgObject.caption;
    }else{
        self.captionLabel.text=@"No caption";
    }

    if (!_isSelf) {
        rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyPost:)];
        
        self.navigationItem.rightBarButtonItem=rightButton;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResponse:) name:RESPONSE_UPDATE object:nil];
    _emptyView.hidden=YES;
    
    self.replyButton.layer.cornerRadius=5.0f;
    self.replyButton.layer.masksToBounds=YES;
    
    nextStr=@"0";
    _noLabel.hidden=YES;
    
    if (_pgObject.responsesCount>0) {
        [self requestForResponses];
    }else{
        if (_isSelf) {
            _emptyView.hidden=YES;
            _noLabel.hidden=NO;
        }else{
            _emptyView.hidden=NO;
            rightButton.enabled=NO;
        }
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
//    if (!isViewLoaded) {
//        isViewLoaded=YES;
//        [_icarouselView reloadData];
//    }
}
-(void)updateResponse:(NSNotification *)notification{
    
    NSDictionary *respDict=[notification.object objectForKey:@"response"];
        PGResponseObject *pgResp = [[PGResponseObject alloc]init];
        for (NSString *respKey in respDict) {
            
            if ([pgResp respondsToSelector:NSSelectorFromString(respKey)]) {
                
                if ([respDict valueForKey:respKey] != NULL) {
                    [pgResp setValue:[respDict valueForKey:respKey] forKey:respKey];
                }
                else{
                    [pgResp setValue:@"" forKey:respKey];
                }
                
            }
        }    
    
    [responsesArray insertObject:pgResp atIndex:0];
    
    _emptyView.hidden=YES;
    rightButton.enabled=YES;
    
    [_icarouselView reloadData];
}
-(void)replyPost:(UIBarButtonItem *)barButton{
    
     AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.pgrespObj=_pgObject;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewCameraViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCamera"];
    newViewController.isPGResponse=YES;
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    [self presentViewController:newNavigation animated:NO completion:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
     [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
    self.navigationController.navigationBar.tintColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
}

-(void)requestForResponses{
    
    [self showActivityWithMessage:nil];
    
    NSString *urlStr;
    if (!_isFriends) {
        urlStr= [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_RESPONSES_LOAD];
    }else{
        urlStr= [NSString stringWithFormat:@"%@%@",kBaseAPI,FRIENDS_RESPONSES];
    }
    
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:_pgObject.id,@"id",nextStr,@"next", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };

    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        NSLog(@"%@",data);
        
        [self hideActivity];
        
        if (error) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            if ([nextStr isEqualToString:@"0"]) {
                [responsesArray removeAllObjects];
            }
            
            NSDictionary *successDict=[data objectForKey:@"success"];
            
            NSArray *challengeArray = [successDict objectForKey:@"responses"];
            
            if (challengeArray.count>0) {
                
                    _emptyView.hidden=YES;
                    rightButton.enabled=YES;
        
            
                nextStr = [successDict objectForKey:@"next"];
                
                if (nextStr.length==0) {
                    nextStr = @"0";
                }
                
                for(NSDictionary *challengeDict in challengeArray){
                    PGResponseObject *pgObject = [[PGResponseObject alloc]init];
                    
                    for (NSString *key in challengeDict) {
                        
                        // NSLog(@"%@",[arrDict valueForKey:key]);
                        
                        if ([pgObject respondsToSelector:NSSelectorFromString(key)]) {
                            
                            if ([challengeDict valueForKey:key] != NULL) {
                                
            
                                    [pgObject setValue:[challengeDict objectForKey:key] forKey:key];
                                }else{
                                    [pgObject setValue:@"" forKey:key];
                                }
                            }
                                
                        }
                    
                        [responsesArray addObject:pgObject];
                    }
                }else{
                    nextStr = @"0";
                    if (_isSelf) {
                        _emptyView.hidden=YES;
                        _noLabel.hidden=NO;
                    }else{
                        _emptyView.hidden=NO;
                        rightButton.enabled=NO;
                    }
                    
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.icarouselView reloadData];
            });
        }
    }];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
//    if (isViewLoaded) {
//        return _pgObject.responses.count;
//    }else{
//        return 0;
//    }
    
    return responsesArray.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(ResponseView *)view
{
    view = nil;
    
    view=[[[NSBundle mainBundle] loadNibNamed:@"ResponseView" owner:self options:nil] objectAtIndex:0];
    view.contentMode = UIViewContentModeCenter;
    view.frame=CGRectMake(10, 10, self.icarouselView.frame.size.height-20, self.icarouselView.frame.size.height-20);
    
    view.countLabel.text=[NSString stringWithFormat:@"%ld",index+1];
    view.totalLabel.text=[NSString stringWithFormat:@"/%ld",(unsigned long)_pgObject.responsesCount];
    PGResponseObject *pgresp=[responsesArray objectAtIndex:index];
    
    [view.responseImage sd_setImageWithURL:[NSURL URLWithString:pgresp.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    view.captionLabel.text=pgresp.caption;
    
//    view.likesCountLabel.text=[NSString stringWithFormat:@"%@",pgresp.stars];
    if (_isFriends) {
        view.likeButton.hidden=YES;
    }else{
        view.likeButton.hidden=NO;
        [view.likeButton setTitle:[NSString stringWithFormat:@"%@",pgresp.stars] forState:UIControlStateNormal];
        
        [view.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    
    if ([pgresp.starredByMe isEqualToString:@"1"]) {
        view.likeButton.selected=YES;
    }else{
        view.likeButton.selected=NO;
    }
    
    
    view.likeButton.tag=index;
    
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

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.icarouselView.itemWidth);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.icarouselView.currentItemIndex));
    
    if (self.icarouselView.currentItemIndex == responsesArray.count-2) {
        if (![nextStr isEqualToString:@"0"]&&nextStr.length) {
            [self requestForResponses];
        }
    }
}
#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %lu", (unsigned long)index);
    
}
-(void)likePost:(UIButton *)button{
    
    if (!button.selected) {
        button.selected=YES;
    }else{
        button.selected=NO;
    }

 
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_STARS];
    
    PGResponseObject *pgresp=[responsesArray objectAtIndex:button.tag];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:pgresp.id,@"id", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {

            NSDictionary *successDict=[data objectForKey:@"success"];
            
            NSString *starStr = [successDict objectForKey:@"stars"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                ResponseView *resView= (ResponseView *)[_icarouselView itemViewAtIndex:button.tag];
                
//                [resView.likeButton setTitle:[NSString stringWithFormat:@"%@",starStr] forState:UIControlStateNormal];
                
                pgresp.stars=[NSString stringWithFormat:@"%@",starStr];
                pgresp.starredByMe=[successDict objectForKey:@"starredByMe"];
                
//                [_icarouselView reloadData];
                
                [_icarouselView reloadItemAtIndex:button.tag animated:YES];
            });
            
        }

    }];
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

- (IBAction)replyAction:(id)sender {
    [self replyPost:nil];
}
@end
