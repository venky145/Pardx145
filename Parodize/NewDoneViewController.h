//
//  NewDoneViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 21/12/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDoneViewController : UIViewController

@property(nonatomic,retain) NSArray *recipientIds;

@property (weak, nonatomic) IBOutlet UIImageView *mockImageView;

@property (weak, nonatomic) IBOutlet UITextField *messageText;

@property (nonatomic,retain) NSString *tagsStr;

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (weak, nonatomic) IBOutlet UIButton *prgCancelButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressStatus;

- (IBAction)cancelAction:(id)sender;

- (IBAction)doneAction:(id)sender;

- (IBAction)progressCancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *sendingLabel;

@property (nonatomic,retain) UIImage *mockImage;


@end
