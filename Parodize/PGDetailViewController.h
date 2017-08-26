//
//  PGDetailViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 19/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "PlayGroundObject.h"
#import "ActivityBaseViewController.h"

@interface PGDetailViewController : ActivityBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;

@property (weak, nonatomic) IBOutlet iCarousel *icarouselView;

@property (nonatomic,retain) PlayGroundObject *pgObject;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

- (IBAction)replyAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property(assign) BOOL isSelf;
@property(assign) BOOL isFriends;

@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@end
