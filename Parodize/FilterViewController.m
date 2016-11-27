//
//  FilterViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 17/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCollectionCell.h"
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"

@interface FilterViewController ()
{
    NSArray *arrEffects;
    UIImage *selectedImage, *thumbImage;
    UIImage *minithumbImage;
}

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated
{
    arrEffects = [[NSMutableArray alloc] initWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",@"",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E1",@"title",@"e1",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E2",@"title",@"e2",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E3",@"title",@"e3",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E4",@"title",@"e4",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E5",@"title",@"e5",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E6",@"title",@"e6",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E7",@"title",@"e7",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E8",@"title",@"e8",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E9",@"title",@"e9",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E10",@"title",@"e10",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E11",@"title",@"e11",@"method", nil],
                  nil];
    
    selectedImage = [UIImage imageNamed:@"After.png"];
    

}

#pragma CollectionView Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //  appsDetails = [AppsMenuTable fetchAppsListDetails:[NSNumber numberWithInt:1]];
    //return [AppsMenuTable checkAppsMenuTableEmpty];
    //    UICollectionViewFlowLayout *aFlowLayout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
    //    [aFlowLayout setSectionInset:UIEdgeInsetsMake(10, 5, 0, 5)];
    
    return 11;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filter" forIndexPath:indexPath];
    
    
    //  [cell.filterImage setImage:[UIImage imageNamed:[itemImagesArray objectAtIndex:indexPath.row]]];
    
    if(((NSString *)[[arrEffects objectAtIndex:indexPath.row] valueForKey:@"method"]).length > 0) {
        SEL _selector = NSSelectorFromString([[arrEffects objectAtIndex:indexPath.row] valueForKey:@"method"]);
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            cell.filterImage.image = [selectedImage performSelector:_selector];
        #pragma clang diagnostic pop
        
    } else
        cell.filterImage.image = selectedImage;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row %d",indexPath.row);
    
    //HomeCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((collectionView.bounds.size.width-20)/3 , (collectionView.bounds.size.height-20)/3 );
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 8;
//}


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

@end
