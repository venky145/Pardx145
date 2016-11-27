//
//  TWActivityBaseViewController.h
//  Titan Watch
//
//  Created by VenkateshX Mandapati on 10/30/15.
//  Copyright © 2015 AnandX Tugaon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityBaseViewController : UIViewController

- (void) showActivityWithMessage:(NSString *) message;
- (void) hideActivity;
-(void) showActivityOnPrsentModule;
- (void) showActivityInView:(UIView *) view withMessage:(NSString *) message;
@end
