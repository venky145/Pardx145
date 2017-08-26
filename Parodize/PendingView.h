//
//  PendingView.h
//  Parodize
//
//  Created by Apple on 12/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    UIView *subView;
    UIView *mainView;
    UITableView *subTableView;
    UIVisualEffectView *effectView;
    UIButton *upButton;
    UILabel *captionLabel;
    UIVisualEffectView *effectView1;
}

@property (nonatomic,retain) UIImageView* originalImage;
@property (nonatomic,retain) NSString* captionStr;
@property (nonatomic,retain) NSArray *pendingUserArray;

@end
