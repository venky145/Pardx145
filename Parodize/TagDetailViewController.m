//
//  TagDetailViewController.m
//  Parodize
//
//  Created by Apple on 17/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "TagDetailViewController.h"
#import "PlayGroundObject.h"
#import "PGResponseObject.h"
#import "PlayGroundCollectionViewCell.h"
#import "PGDetailViewController.h"


@interface TagDetailViewController ()
{
    
    NSMutableArray *tagRelatedArray;
    
    NSString *nextStr;
    
    BOOL isNext;
    
    NSIndexPath* selectedIndex;
    
}
@end

@implementation TagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tagRelatedArray = [[NSMutableArray alloc]init];
        nextStr=@"0";
    self.title=[NSString stringWithFormat:@"# %@",_tagObject.tag];

   [self requestTagDetail];

        
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
//        self.navigationController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    [[Context contextSharedManager] makeNormalNavigationBar:self.navigationController];
    

}

-(void)requestTagDetail{
    
    [self showActivityInView:self.view withMessage:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_RELATED];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_tagObject.id],@"id",nextStr,@"next", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        NSLog(@"%@",data);
        
        [self hideActivity];
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            if (!isNext) {
                [tagRelatedArray removeAllObjects];
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
                            
                            }else
                                [pgObject setValue:@"" forKey:key];
                        }
                    }
                    [tagRelatedArray addObject:pgObject];
                    
                }
            }else{
                nextStr = @"0";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
            });
            
        }
    }];
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tagRelatedArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_c cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellGrid";
    
    PlayGroundCollectionViewCell *cell =(PlayGroundCollectionViewCell *) [collectionView_c dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PlayGroundObject *pgObj=[tagRelatedArray objectAtIndex:indexPath.row];
    
    [cell.pgImageView sd_setImageWithURL:[NSURL URLWithString:pgObj.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    
    cell.timeLabel.text=[[Context contextSharedManager] setDateInterval:pgObj.time];
    
    cell.captionLabel.text=pgObj.caption;
    cell.distanceLabel.text=[NSString stringWithFormat:@"%ld km",(long)[pgObj.distance integerValue]];
    if (pgObj.responsesCount==0) {
        cell.countLabel.hidden=YES;
    }else{
        
        cell.countLabel.hidden=NO;
        cell.countLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)pgObj.responsesCount];
    }
    if(indexPath.row == [tagRelatedArray count]-3){
        //Last cell was drawn
        if (![nextStr isEqualToString:@"0"]) {
            if (nextStr.length>0) {
                isNext = YES;
                [self requestTagDetail];
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
    selectedIndex = indexPath;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"pgDetailSegue"]) {
 
 PGDetailViewController *destViewController = segue.destinationViewController;
 destViewController.pgObject=[tagRelatedArray objectAtIndex:selectedIndex.row];
 }
 }

@end
