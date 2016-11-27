//
//  CamOverlayViewController.h
//  Parodize
//
//  Created by administrator on 17/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamOverlayViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)snapShotAction:(id)sender;
- (IBAction)camRotate:(id)sender;
- (IBAction)camFlash:(id)sender;

@end
