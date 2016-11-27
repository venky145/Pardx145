//
//  TWActivityIndicator.h
//  Titan Watch
//
//  Created by VenkateshX Mandapati on 10/30/15.
//  Copyright © 2015 VenkateshX Mandapati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRActivityIndicator : UIView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityMessageLbl;

+ (PRActivityIndicator *) createTGCActivityIndicator;

@end
