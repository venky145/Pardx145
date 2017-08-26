//
//  SearchTagsViewController.h
//  Parodize
//
//  Created by Apple on 17/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Tags+CoreDataClass.h"

@interface SearchTagsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tagsTableView;
@property (weak, nonatomic) IBOutlet UILabel *noTagsLabel;

//@property(nonatomic,retain) Tags *tagData;

- (IBAction)cancelAction:(id)sender;

@end
