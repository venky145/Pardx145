//
//  NewCameraViewController.h
//  Parodize
//
//  Created by Apple on 14/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ImageScrollView.h"
#import "ActivityBaseViewController.h"

@interface NewCameraViewController : ActivityBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>


@property (nonatomic) dispatch_queue_t sessionQueue;
@property (assign) BOOL isPlayGround;
@property (assign) BOOL isPGResponse;
@property (assign) BOOL isFriend;
@property (weak, nonatomic) IBOutlet UIButton *camSwitch;

@property (weak, nonatomic) IBOutlet UIButton *camSnapButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoLibrary;

@property (weak, nonatomic) IBOutlet UIView *cameraView;

- (IBAction)switchAction:(id)sender;

- (IBAction)snapAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *camContainerView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
- (IBAction)flashAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property(nonatomic,retain) AVCaptureVideoPreviewLayer *previewLayer;

@end
