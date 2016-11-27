//
//  EditProfileViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 10/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Profile.h"

@interface EditProfileViewController : ActivityBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

- (IBAction)doneAction:(id)sender;

@property(nonatomic,retain) UIImage *getImage;

@property(nonatomic,retain) User_Profile *editUserProfile;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
