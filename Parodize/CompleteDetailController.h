//
//  CompleteDetailController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedModelClass.h"

@interface CompleteDetailController : UIViewController

@property (nonatomic,retain) CompletedModelClass *completedModel;

@property (strong, nonatomic) IBOutlet UIImageView *originalImage;
@property (strong, nonatomic) IBOutlet UIImageView *mockImage;
@property (strong, nonatomic) IBOutlet UITextView *originaltags;
@property (strong, nonatomic) IBOutlet UITextView *mockTags;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
- (IBAction)twitterAction:(id)sender;
- (IBAction)fbAction:(id)sender;
@end
