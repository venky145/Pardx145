//
//  DrawLine.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 31/08/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawLine : UIView{
    
    UIBezierPath *bezierPath;
    CGPoint lastPoint;
   // UIColor *brushColor;
    
    
}

@property (nonatomic,weak) UIColor *brushColor;
@property (nonatomic) NSMutableArray* bezierArray;

-(UIImage *)getImageFromDrawView;

@end
