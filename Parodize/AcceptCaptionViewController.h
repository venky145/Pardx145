//
//  AcceptCaptionViewController.h
//  Parodize
//
//  Created by Apple on 27/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptCaptionViewController : UIViewController
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *captionView;
@property (nonatomic,retain) UIImage *mockImage;
@property (weak, nonatomic) IBOutlet UITextField *captionText;

@end
