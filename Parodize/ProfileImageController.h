//
//  ProfileImageController.h
//  Parodize
//
//  Created by Apple on 13/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageController : UIViewController

@property(weak,nonatomic) UIImage *profileData;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (IBAction)closeAction:(id)sender;

@end
