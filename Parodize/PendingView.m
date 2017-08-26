//
//  PendingView.m
//  Parodize
//
//  Created by Apple on 12/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "PendingView.h"
#import "PendingUserObject.h"
#import "PendingCell.h"

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)


@implementation PendingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        
        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swiperight];
      
        
        self.pendingUserArray=[[NSMutableArray alloc]init];
        
        subTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        subTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        subTableView.delegate=self;
        subTableView.dataSource=self;
        
        self.backgroundColor=[UIColor clearColor];
        mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-10)];
        mainView.layer.cornerRadius=10.0f;
        mainView.layer.masksToBounds=YES;
        mainView.layer.borderWidth=1.0f;
        mainView.layer.borderColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR].CGColor;
        mainView.clipsToBounds=YES;
        
        mainView.backgroundColor=[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
        
        _originalImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.width)];
        _originalImage.backgroundColor=[UIColor greenColor];
        
        [mainView addSubview:_originalImage];
        
         subView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_originalImage.frame),mainView.frame.size.width , mainView.frame.size.height-_originalImage.frame.size.height)];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
        [effectView setEffect:blurEffect];
        
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched:)];
//        
//        [effectView addGestureRecognizer:tap];
        
        UIVisualEffect *blurEffect1;
        blurEffect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        effectView1 = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_originalImage.frame)-40, mainView.frame.size.width, 40)];
        [effectView1 setEffect:blurEffect];
        
        captionLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, effectView1.frame.size.width-10, 40)];
        
        captionLabel.textColor=[UIColor whiteColor];
        captionLabel.font=[UIFont systemFontOfSize:14];
        captionLabel.backgroundColor=[UIColor clearColor];
        captionLabel.numberOfLines = 2; //will wrap text in new line
        
        
        [effectView1 addSubview:captionLabel];
        
        upButton=[[UIButton alloc]initWithFrame:CGRectMake(effectView.center.x-60, 0, 120, subView.frame.size.height)];
        [upButton setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
        [upButton addTarget:self action:@selector(upButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [effectView addSubview:upButton];
        
        [subView addSubview:effectView];
        [mainView addSubview:effectView1];
        [mainView addSubview:subView];
        [self addSubview:mainView];
        [self bringSubviewToFront:upButton];
        
        UISwipeGestureRecognizer *swipeGestUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeGestDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeGestUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [swipeGestDown setDirection:UISwipeGestureRecognizerDirectionDown];
        
        [self addGestureRecognizer:swipeGestUp];
        [self addGestureRecognizer:swipeGestDown];
    }
    return self;
}
-(void)touched:(UITapGestureRecognizer *)gesture{
    NSLog(@"Touched");
}
-(void)handleSwipe:(UISwipeGestureRecognizer *)gesture{
    NSLog(@"Swipe");
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        [self hidesTableView];
    }else{
        [self showsTableView];
    }
}
-(void)hidesTableView{
     upButton.selected=NO;
    upButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        subView.frame = CGRectMake(0, CGRectGetMaxY(_originalImage.frame),mainView.frame.size.width,CGRectGetMaxY(mainView.frame)-CGRectGetMaxY(_originalImage.frame));
        effectView.frame = CGRectMake(0,0,mainView.frame.size.width,CGRectGetMaxY(mainView.frame)-CGRectGetMaxY(_originalImage.frame));
    } completion:^(BOOL finished) {
        [subTableView removeFromSuperview];
        //        [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //            self.headerView.frame  = CGRectMake(0, -30, 320,30);
        //
        //        } completion:^(BOOL finished) {
        //
        //        }];
        
    }];
}
-(void)swipeLeft:(UISwipeGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwipe" object:nil];
}
-(void)swipeRight:(UISwipeGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rightSwipe" object:nil];
}
-(void)showsTableView{
    
    upButton.selected=YES;
    upButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    
    CGRect subFrame = subView.frame;
    
    subFrame.origin.y= 50;
    
    subFrame.size.height = mainView.frame.size.height-50;
    
    subTableView.frame=CGRectMake(0, subView.frame.size.height, subFrame.size.width, subFrame.size.height-subView.frame.size.height);
    
//    subTableView = [[UITableView alloc]
    
    
    subTableView.backgroundColor=[UIColor clearColor];
    
    [effectView addSubview:subTableView];
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        subView.frame  = subFrame;
        effectView.frame=CGRectMake(0,0,subFrame.size.width,subFrame.size.height);
    } completion:^(BOOL finished) {
    }];

}
-(void)upButtonAction:(UIButton *)button{
    
    if (button.selected) {
        [self hidesTableView];
       
    }else{
        [self showsTableView];

            }
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
    
    if (_pendingUserArray.count>0) {
        [subTableView reloadData];
    }
    if (_captionStr.length>0) {
        captionLabel.text=_captionStr;
        captionLabel.textAlignment=NSTextAlignmentLeft;
        effectView1.hidden=NO;
    }else{
        effectView1.hidden=YES;
    }
    
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pendingUserArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"editCell";

    PendingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PendingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }


    PendingUserObject *userObj=[_pendingUserArray objectAtIndex:indexPath.row];
    
    [cell.mockImage sd_setImageWithURL:[NSURL URLWithString:userObj.thumbnail] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
    
    cell.nameLabel.text=[NSString stringWithFormat:@"%@ %@",userObj.firstname,userObj.lastname];
    cell.nameLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
