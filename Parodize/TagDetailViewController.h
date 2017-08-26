//
//  TagDetailViewController.h
//  Parodize
//
//  Created by Apple on 17/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTagObject.h"
#import "ActivityBaseViewController.h"
#import "Tags+CoreDataClass.h"

@interface TagDetailViewController : ActivityBaseViewController

@property(nonatomic,retain) SearchTagObject *tagObject;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) Tags *tagsData;

@end
