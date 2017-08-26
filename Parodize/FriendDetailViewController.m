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
#import "CamOverlayViewController.h"
#import "Context.h"
#import "FriendsChallenge.h"
#import "PlayGroundCollectionViewCell.h"
#import "PGDetailViewController.h"
#import "PlayGroundObject.h"
#import "NewCameraViewController.h"

@interface FriendDetailViewController (){
    
    FriendDetailObject *fDetailObj;
    NSMutableArray *challengesArray;
    
    NSString *nextStr;
    
    BOOL isNext;
    
    CGRect colllectionFrame;
    CGRect contentFrame;

    BOOL isHidden;
    
    NSIndexPath* selfSelectedIndex;
    
    AppDelegate *appDelegate;
}

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    challengesArray = [[NSMutableArray alloc]init];
    
    nextStr = @"0";

    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_friendObj.thumbnail] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
     [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_friendObj.thumbnail] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    
    
    [[Context contextSharedManager] roundImageView:self.profileImageView withValue:self.profileImageView.frame.size.height/2];
    
    self.friendName.text=[[Context contextSharedManager]assignFriendName:_friendObj];

    [self.scoreButton setTitle:[NSString stringWithFormat:@"%@",_friendObj.score] forState:UIControlStateNormal];
    
    _addFriendButton.hidden=YES;
    _challengeButton.hidden=YES;
    _followButton.hidden=YES;

    
    contentFrame = self.profileView.frame;
    
    self.challengeCollection.frame=CGRectMake(0, CGRectGetMaxY(contentFrame), self.view.frame.size.width, self.view.frame.size.height-contentFrame.size.height);
    
    colllectionFrame = self.challengeCollection.frame;
    
    _noLabel.hidden=YES;

    [self getFriendDetails];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)viewDidAppear:(BOOL)animated{
    
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return challengesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_c cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellGrid";
    
    PlayGroundCollectionViewCell *cell =(PlayGroundCollectionViewCell *) [collectionView_c dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PlayGroundObject *pgObj=[challengesArray objectAtIndex:indexPath.row];
    
    [cell.pgImageView sd_setImageWithURL:[NSURL URLWithString:pgObj.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    
    cell.timeLabel.text=[[Context contextSharedManager] setDateInterval:pgObj.time];
    
    cell.captionLabel.text=pgObj.caption;

    if (pgObj.responsesCount==0) {
        cell.countLabel.hidden=YES;
    }else{
        
        cell.countLabel.hidden=NO;
        cell.countLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)pgObj.responsesCount];
    }
    if(indexPath.row == [challengesArray count]-3){
        //Last cell was drawn
        if (![nextStr isEqualToString:@"0"]) {
            if (nextStr.length>0) {
                isNext = YES;
                [self getResponseDetails];
            }else{
                nextStr = @"0";
                isNext = NO;
            }
        }
        
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selfSelectedIndex = indexPath;
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
CGPoint _lastContentOffset;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset;
    
//    NSLog(@"%f---%f",_lastContentOffset.y,scrollView.contentOffset.y);
//    static CGFloat previousOffset;
//    CGRect rect = self.view.frame;
//    rect.origin.y += previousOffset - scrollView.contentOffset.y;
//    previousOffset = scrollView.contentOffset.y;
//    self.view.frame = rect;
    
//    [self.view layoutIfNeeded];
    
    if (_lastContentOffset.y > 0.0f) {
        NSLog(@"down");
        
        if (!isHidden) {
            isHidden = YES;
            CGRect editFrame = _challengeCollection.frame;
            
            editFrame.origin.y=64;
            editFrame.size.height=self.view.frame.size.height-64;
            
            _challengeCollection.frame=editFrame;
            
            [self updateFrame:editFrame withTitleHidden:YES];
        }
       
        
    }else if(_lastContentOffset.y <= 0.0f){
        
        NSLog(@"zero");
        if (isHidden) {
            isHidden=NO;
             [self updateFrame:colllectionFrame withTitleHidden:NO];
        }
       
        
    }
}

-(void)updateFrame:(CGRect)newFrame withTitleHidden:(BOOL)hidden{
    _profileView.translatesAutoresizingMaskIntoConstraints = NO;
    _challengeCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                          _challengeCollection.frame=newFrame;
                         if (hidden) {
                             self.title=[[Context contextSharedManager]assignFriendName:_friendObj];
                             self.view.backgroundColor=[[UIColor darkGrayColor] colorWithAlphaComponent:0.1f];
                             CGRect editFrame = _profileView.frame;
                             editFrame.size.height= 64;
                             
                             _profileView.frame=editFrame;
                         }else{
                             self.title=nil;
//                             _profileView.frame=contentFrame;
                    
                         }
                        
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
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
}
-(void)getFriendDetails{
    
    [self showActivityWithMessage:nil];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_friendObj.f_id,@"id", nil];
    [[DataManager sharedDataManager] friendsDetails:dict forSender:self];
}
-(void)getResponseDetails{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,FRIENDS_CHALLENGES];
    NSDictionary *dict;

    if ([nextStr isEqualToString:@"0"]) {
        dict=[NSDictionary dictionaryWithObjectsAndKeys:_friendObj.f_id,@"id",@"0",@"next",nil];
    }else{
        dict=[NSDictionary dictionaryWithObjectsAndKeys:_friendObj.f_id,@"id",nextStr,@"next",nil];
    }
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        [self hideActivity];
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            
            if (!isNext) {
                [challengesArray removeAllObjects];
            }
            
            NSDictionary *successDict=[data objectForKey:@"success"];
            
            if ([successDict objectForKey:@"challenges"]) {
                NSArray *challengeArray = [successDict objectForKey:@"challenges"];
                
                if (challengeArray.count>0) {
                    
                    nextStr = [successDict objectForKey:@"next"];
                    
                    if (nextStr.length==0) {
                        nextStr = @"0";
                    }
                    
                    for(NSDictionary *challengeDict in challengeArray){
                        PlayGroundObject *challengeObject = [[PlayGroundObject alloc]init];
                        
                        for (NSString *key in challengeDict) {
                            
                            // NSLog(@"%@",[arrDict valueForKey:key]);
                            
                            if ([challengeObject respondsToSelector:NSSelectorFromString(key)]) {
                                
                                if ([challengeDict valueForKey:key] != NULL) {
                                    
                                    [challengeObject setValue:[challengeDict valueForKey:key] forKey:key];
                                }
                                else
                                    [challengeObject setValue:@"" forKey:key];
                            }
                        }
                        
                        [challengesArray  addObject:challengeObject];
                    }
                }else{
                    nextStr = @"0";
                    _noLabel.hidden=NO;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.challengeCollection reloadData];
                });
            }
        }
    }];
}
-(void) didGetFriendDetails:(NSMutableDictionary *) dataDictionary{
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    
    
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        [self hideActivity];
         [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionary objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
//        [self getResponseDetails];
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
            [self.scoreButton setTitle:[NSString stringWithFormat:@"%@",fDetailObj.score] forState:UIControlStateNormal];
            _addFriendButton.hidden=YES;
            _challengeButton.hidden=NO;
            _followButton.hidden=NO;
            
             [self getResponseDetails];
            
        }else if (fDetailObj.isFriend == 1){
            [_addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
            _addFriendButton.enabled=NO;
            _challengeButton.hidden=YES;
            _followButton.hidden=YES;
        }else if (fDetailObj.isFriend == 0){
            [_addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
            _addFriendButton.hidden=NO;
            _addFriendButton.enabled=YES;
            _challengeButton.hidden=YES;
            _followButton.hidden=YES;
        }
        
       
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
   [[Context contextSharedManager] showAlertView:self withMessage:SERVER_ERROR withAlertTitle:SERVER_ERROR];
    
    
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
    
    appDelegate.friendId=_friendObj.f_id;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewCameraViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCamera"];
    newViewController.isPlayGround=NO;
    newViewController.isFriend=YES;
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    [self presentViewController:newNavigation animated:NO completion:nil];
    
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    NewCameraViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCamera"];
//    newViewController.isPlayGround=NO;
//    newViewController.isFriend=YES;
//    
//    [self presentViewController:newViewController animated:NO completion:nil];

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
                 
                 
                 [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
                 
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
              [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
         }
     }];
    
    [manager.operationQueue addOperation:operation];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pgDetailSegue"]) {
        
        PGDetailViewController *destViewController = segue.destinationViewController;
        destViewController.isSelf=YES;
        destViewController.isFriends=YES;
        destViewController.pgObject=[challengesArray objectAtIndex:selfSelectedIndex.row];
    }
}

@end
