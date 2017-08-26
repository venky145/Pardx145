//
//  SecondViewController.h
//  Parodize
//
//  Created by administrator on 09/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceViewController.h"
#import "ActivityBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PlayGroudViewController : ActivityBaseViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *distanceButton;


@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
- (IBAction)challengeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *pdCollectionView;
- (IBAction)searchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *selfButton;
- (IBAction)allAction:(id)sender;
- (IBAction)selfAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *navView;


@end

