//
//  ChooseRecipientViewController.h
//  Parodize
//
//  Created by administrator on 18/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseRecipientViewController : ActivityBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *recipientsTableView;
@property (nonatomic,retain) NSString *tagsList;
@property (nonatomic,retain) UIImage *getImage;

- (IBAction)sendAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
