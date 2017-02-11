//
//  PenViewController.h
//  Parodize
//
//  Created by VenkateshX Mandapati on 31/08/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawLine.h"

@interface PenViewController : UIViewController

@property (strong) UIImage *getImage;
@property (strong, nonatomic) IBOutlet UIImageView *editImageView;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet DrawLine *drawLineView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridLayout;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *snapView;



@end
