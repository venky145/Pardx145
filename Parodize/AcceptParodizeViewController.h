//
//  AcceptParodizeViewController.h
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptModelClass.h"
#import "ActivityBaseViewController.h"

@interface AcceptParodizeViewController : ActivityBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property(assign)BOOL isNotification;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)takePicture:(id)sender;

- (IBAction)switchCamera:(id)sender;

- (IBAction)cameraFullScreen:(id)sender;

- (IBAction)flashCamera:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImageView;

@property (nonatomic,strong) NSString *acceptImage;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
//@property(nonatomic,strong) NSString *getTimeStr;
//@property(nonatomic,strong) NSString *getmessageText;
//@property(nonatomic,strong) NSNumber *getId;

@property(nonatomic,retain) AcceptModelClass *acceptModel;


@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *snapImageView;
- (IBAction)retakeAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *cameraRoll;
- (IBAction)cameraGesture:(id)sender;
- (IBAction)mockGesture:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
- (IBAction)backAction:(id)sender;

@end
