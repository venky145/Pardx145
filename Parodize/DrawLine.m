//
//  DrawLine.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 31/08/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       
        
        [self initialSetup];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialSetup];
    }
    return self;
}

-(void)initialSetup
{
     self.bezierArray=[[NSMutableArray alloc]init];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    for (NSMutableDictionary *bPathDict in _bezierArray ) {
     
        UIBezierPath *_path = [bPathDict objectForKey:@"Path"];
        
        UIColor *_colors = [bPathDict objectForKey:@"Colors"];
        
        [_colors setStroke];
        
       // _path.lineCapStyle = kCGLineCapRound;
        
        [bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
        [_path stroke];
        //[_brushColor setStroke];
        //[bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        // Drawing code
        //[bezierPath stroke];
    }
    
    
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PencilDraw" object:nil];
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    UIBezierPath *bezier=[[UIBezierPath alloc]init];
    bezier.lineCapStyle=kCGLineCapRound;
    bezier.miterLimit=0;
    bezier.lineWidth=10;

    [bezier moveToPoint:[mytouch locationInView:self]];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init]; //locally created
    
    [dict setObject:bezier forKey:@"Path"];
    
    [dict setObject:_brushColor forKey:@"Colors"];
    
    [_bezierArray addObject:dict];
    bezierPath=bezier;
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [bezierPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
        
}
-(UIImage *)getImageFromDrawView{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
/*
- (void)drawRect:(CGRect)rect
{
    //    [_brushColor setStroke];
    //    [bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    //    // Drawing code
    //    [bezierPath stroke];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 10);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, lastPoint.x, lastPoint.y);
    CGContextSetStrokeColorWithColor(context, _brushColor.CGColor);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    //[bezierPath moveToPoint:[mytouch locationInView:self]];
    lastPoint = [mytouch locationInView:self];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    //[bezierPath addLineToPoint:[mytouch locationInView:self]];
    
    CGPoint currentPoint = [mytouch locationInView:self];
    lastPoint = currentPoint;
    [self setNeedsDisplay];
    
}
*/


@end
