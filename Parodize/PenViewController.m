//
//  PenViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 31/08/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "PenViewController.h"
#import "DrawLine.h"

@interface PenViewController ()
{
    NSMutableArray *colorsArray;
    
    UICollectionViewCell *prevCell;
    
    BOOL isEdited;
}

@end

@implementation PenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    DrawLine *drawScreen=[[DrawLine alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:drawScreen];
    
    
//    [_editImageView setImage:[[Context contextSharedManager] imageWithImage:_getImage scaledToSize:_editImageView.frame.size]];
    
    _editImageView.image=_getImage;
    
    
    [_doneButton setEnabled:NO];
    
    colorsArray=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor whiteColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    
    _drawLineView.brushColor=[UIColor blackColor];
    
}
-(void)isDrawn:(NSNotification *)notification{
    
    isEdited=YES;
    [_doneButton setEnabled:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return colorsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor=[colorsArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell=[collectionView cellForItemAtIndexPath:indexPath];
    _drawLineView.brushColor=[colorsArray objectAtIndex:indexPath.row];
    if (prevCell) {
        prevCell.layer.borderColor=[UIColor clearColor].CGColor;
        prevCell.layer.masksToBounds=YES;
    }
    selectedCell.layer.borderColor=[UIColor whiteColor].CGColor;
    selectedCell.layer.borderWidth=2.0f;
    selectedCell.layer.masksToBounds=YES;
    prevCell=selectedCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(20, 20);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)doneAction:(id)sender {

    [_doneButton removeFromSuperview];
    [_cancelButton removeFromSuperview];
    
    [_gridLayout removeFromSuperview];
    
    
//    UIGraphicsBeginImageContextWithOptions(_drawLineView.frame.size, NO, 0.0); //retina res
//    [_drawLineView.layer renderInContext:UIGraphicsGetCurrentContext()];
//   // [_editImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIGraphicsBeginImageContext(_editImageView.frame.size);
//    [_editImageView.image drawAtPoint:CGPointMake(0,0)];
//    [image drawAtPoint:CGPointMake(0,0)];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContext(CGSizeMake(self.snapView.frame.size.width, self.snapView.frame.size.height));
     UIGraphicsBeginImageContextWithOptions(_snapView.frame.size, NO, 0.0);
    
    [self.snapView.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *answer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

//    UIImageWriteToSavedPhotosAlbum(answer,
//                                   nil,
//                                   nil,
//                                   nil);
    
    
    
    //return answer;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawImage" object:answer];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
