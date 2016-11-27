//
//  SecondViewController.h
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceViewController.h"

@interface PlayGroudViewController : UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *distanceButton;


@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
- (IBAction)challengeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)upScrollAction:(id)sender;

- (IBAction)downScrollAction:(id)sender;

@end

