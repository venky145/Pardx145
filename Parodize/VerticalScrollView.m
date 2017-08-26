//
//  VerticalScrollView.m
//  Parodize
//
//  Created by Apple on 04/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "VerticalScrollView.h"

#define yPadding ((int)0)
#define yPaddingHalf ((int)5)

@implementation VerticalScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        
        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swiperight];
        
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-10)];
        mainView.layer.cornerRadius=10.0f;
        mainView.layer.masksToBounds=YES;
        
        mainView.backgroundColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, yPaddingHalf/2,frame.size.width-yPaddingHalf, 20)];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.textColor=[UIColor whiteColor];
        
        double imageSize= (frame.size.width-2*yPadding)/2-(yPaddingHalf/2);
        
        _originalImage = [[UIImageView alloc]initWithFrame:CGRectMake(yPaddingHalf/2, CGRectGetMaxY(_titleLabel.frame)+yPaddingHalf/2, imageSize-2, imageSize-2)];
        _originalImage.backgroundColor=[UIColor greenColor];
        
        _mockImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_originalImage.frame)+yPaddingHalf/2, CGRectGetMaxY(_titleLabel.frame)+yPaddingHalf/2, imageSize-2,imageSize-2)];
        
        _mockImage.backgroundColor=[UIColor grayColor];
        
        _originalCaption = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_originalImage.frame), CGRectGetMaxY(_originalImage.frame)+yPaddingHalf,_originalImage.frame.size.width-yPaddingHalf, 50)];
        _originalCaption.textColor=[UIColor whiteColor];
        _originalCaption.textAlignment=NSTextAlignmentCenter;
        
        _mockCaption = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mockImage.frame)+yPaddingHalf, CGRectGetMaxY(_mockImage.frame)+yPaddingHalf,_mockImage.frame.size.width-yPaddingHalf, 50)];
        _mockCaption.textColor=[UIColor whiteColor];
        _mockCaption.textAlignment=NSTextAlignmentCenter;
        
         UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_originalImage.frame), _originalCaption.frame.origin.y+yPaddingHalf*3, 2, 20)];
        
        lineView.backgroundColor=[UIColor blackColor];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x-40, CGRectGetMaxY(_mockCaption.frame)+10,80, 30)];
        shareLabel.textColor=[UIColor grayColor];
        shareLabel.text=@"Share with";
        shareLabel.font=[UIFont boldSystemFontOfSize:12];
        shareLabel.textAlignment=NSTextAlignmentCenter;
        
        UIButton *fbButton = [[UIButton alloc]initWithFrame:CGRectMake(self.center.x-45,CGRectGetMaxY(shareLabel.frame) , 40, 40)];
        
        [fbButton addTarget:self action:@selector(faceBookAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [fbButton setImage:[UIImage imageNamed:@"fbShare"] forState:UIControlStateNormal];
        
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(self.center.x+5,CGRectGetMaxY(shareLabel.frame) , 40, 40)];
        
        [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [shareButton setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
        
        UILabel *visibleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x+50,CGRectGetMaxY(shareButton.frame)+10, 70, 20)];
        visibleLabel.text=@"Visible to all";
        visibleLabel.font=[UIFont systemFontOfSize:12];
        visibleLabel.textColor=[UIColor whiteColor];
        
        _visibleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(visibleLabel.frame), CGRectGetMinY(visibleLabel.frame), 50, 20)];
        _visibleSwitch.transform = CGAffineTransformMakeScale(0.50, 0.50);
        _visibleSwitch.onTintColor = [UIColor blueColor];
        CGPoint centerPoint = visibleLabel.center;
        centerPoint.x=CGRectGetMaxX(visibleLabel.frame)+20;
        _visibleSwitch.center=centerPoint;
        [_visibleSwitch addTarget:self action:@selector(visibleAction:) forControlEvents:UIControlEventValueChanged];
        
        [mainView addSubview:_titleLabel];
        [mainView addSubview:_originalImage];
        [mainView addSubview:_mockImage];
        [mainView addSubview:_originalCaption];
        [mainView addSubview:_mockCaption];
        [mainView addSubview:lineView];
        [mainView addSubview:shareLabel];
        [mainView addSubview:fbButton];
        [mainView addSubview:shareButton];
        [mainView addSubview:visibleLabel];
        [mainView addSubview:_visibleSwitch];
        
        [self addSubview:mainView];
    }
    return self;
}
-(void)swipeLeft:(UISwipeGestureRecognizer *)gesture{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwipe" object:nil];
}
-(void)swipeRight:(UISwipeGestureRecognizer *)gesture{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"rightSwipe" object:nil];
}
-(void)faceBookAction:(UIButton *)button{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookShare" object:nil];
}
-(void)shareAction:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareAction" object:nil];
}
-(void)visibleAction:(id)sender{
    UISwitch *visSwitch = (UISwitch *)sender;

     [[NSNotificationCenter defaultCenter] postNotificationName:@"visibleAction" object:visSwitch.on ?@"1": @"0"];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Define path
    CGContextMoveToPoint(context, self.bounds.size.width / 2.0- 5,10);
    CGContextAddLineToPoint(context, self.bounds.size.width / 2.0 + 5,
                            10);
    CGContextAddLineToPoint(context, self.bounds.size.width / 2.0,
                            0);
    
    CGContextSetStrokeColorWithColor(context, [[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR] CGColor]);
    CGContextSetFillColorWithColor(context, [[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR] CGColor]);
//    CGContextFillRect(context)
    
    CGContextFillPath(context);
    
    // Finalize and draw using path
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    
}


@end
