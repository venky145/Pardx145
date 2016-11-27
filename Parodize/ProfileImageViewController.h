//
//  ProfileImageViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileImageViewController : ActivityBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)cameraAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)skipAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@end
