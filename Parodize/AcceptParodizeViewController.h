//
//  AcceptParodizeViewController.h
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptParodizeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (weak, nonatomic) IBOutlet UIView *suggestionView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *optionsSegment;


- (IBAction)segmentAction:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *cameraPoint;
@property (weak, nonatomic) IBOutlet UIImageView *messagePoint;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionPoint;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)takePicture:(id)sender;

- (IBAction)switchCamera:(id)sender;

- (IBAction)cameraFullScreen:(id)sender;

- (IBAction)flashCamera:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImageView;

@property (nonatomic,strong) NSString *acceptImage;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextiew;


@property(nonatomic,strong) NSString *getTimeStr;
@property(nonatomic,strong) NSString *getmessageText;
@property(nonatomic,strong) NSNumber *getId;

@end
