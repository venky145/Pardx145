//
//  AcceptSendViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 10/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptSendViewController : UIViewController

@property (nonatomic,assign) BOOL isAccept;

@property (weak, nonatomic) IBOutlet UIImageView *originalImage;

@property (weak, nonatomic) IBOutlet UIImageView *mockImage;

@property (nonatomic,retain) UIImage *getImage;
@property (nonatomic,retain) UIImage *getMockImage;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (weak, nonatomic) IBOutlet UIView *sendView;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic,strong) NSNumber *acceptID;
@property (nonatomic,strong) NSString *captionName;
@property (weak, nonatomic) IBOutlet UITextView *mockCaption;
@property (weak, nonatomic) IBOutlet UITextView *currentCaption;

- (IBAction)sendAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *progressStatus;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelAction:(id)sender;
@end
