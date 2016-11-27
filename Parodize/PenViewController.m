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
}

@end

@implementation PenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    DrawLine *drawScreen=[[DrawLine alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:drawScreen];
    
    _editImageView.image=_getImage;
    
    
    colorsArray=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor whiteColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    
    _drawLineView.brushColor=[UIColor blackColor];
    
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
    
   /* UIImage *drawImage=[_drawLineView getImageFromDrawView];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height), YES, 0.0);
    
    [drawImage drawAtPoint: CGPointMake(0,0)];
    
    [drawImage drawAtPoint: CGPointMake(0,0)
              blendMode: kCGBlendModeNormal // you can play with this
                  alpha: 1]; // 0 - 1
    
    UIImage *answer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
  /*  let rect : CGRect = CGRect() //Your view size from where you want to make UIImage
    UIGraphicsBeginImageContext(rect.size);
    let context : CGContextRef = UIGraphicsGetCurrentContext()
    self.view.layer.renderInContext(context)
    let img : UIImage  = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    */
    
    [_doneButton removeFromSuperview];
    [_cancelButton removeFromSuperview];
    
    [_gridLayout removeFromSuperview];
    
    UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
                            
    [self.snapView.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *answer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    //return answer;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawImage" object:answer];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
