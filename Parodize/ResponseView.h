//
//  ResponseView.h
//  Parodize
//
//  Created by Apple on 19/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *responseImage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;

- (IBAction)likeAction:(UIButton *)sender;
@end
