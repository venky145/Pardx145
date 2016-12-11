//
//  PendingTableViewController.m
//  Parodize
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "PendingTableViewController.h"
#import "PendingCell.h"
#import "CompletedModelClass.h"

@interface PendingTableViewController (){
    
    NSMutableArray *pendingArray;
    BOOL isLastIndex;
    NSString *nextReqStr;
    
}

@end

@implementation PendingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    pendingArray=[[NSMutableArray alloc]init];
    
     self.pendingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    nextReqStr=@"0";
    
    [self requestPendingChallenges];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestPendingChallenges{
    
    [self.activityIndicator startAnimating];
    
    [self.loadingLabel setText:@"Loading ..."];
    
    self.pendingTableView.hidden=YES;
    self.loadingLabel.hidden=NO;
    self.activityIndicator.hidden=NO;
    
    [self requestPendingList];
}
-(void)requestPendingList{
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:nextReqStr,@"next", nil];
    
    [[DataManager sharedDataManager] requestPendingChallenges:dict forSender:self];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 5;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return pendingArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    PendingCell *cell =(PendingCell *) [tableView dequeueReusableCellWithIdentifier:@"PendingCell" forIndexPath:indexPath];
    
    if (cell==nil) {
        
        NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];
        cell=[cellArray objectAtIndex:0];
    }
    
    CompletedModelClass *modelClass=[pendingArray objectAtIndex:indexPath.row];
    
    if (modelClass.message.length>0) {
        cell.messageText.text=modelClass.message;
    }else
        cell.messageText.text=@"No Message";
    
    
    NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:modelClass.challengeThumbnail];
    
    cell.mockImage.image = [UIImage imageWithData:imageData];
    
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isLastIndex&&indexPath.row==pendingArray.count-1) {
        
        isLastIndex=YES;
        
        if (![nextReqStr isEqualToString:@"0"]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self requestPendingList];
            });
        }
        
    }
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
}

#pragma DataManagerDelegate  Methods

-(void) didGetPendingChallenges:(NSMutableDictionary *) dataDictionary {
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    
    [self.activityIndicator stopAnimating];
    
    self.activityIndicator.hidden=YES;
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dataDictionary objectForKey:RESPONSE_ERROR]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
        NSArray *resultArray=[successDict objectForKey:@"pending"];
        
        if (resultArray.count>0) {
            
            self.loadingLabel.hidden=YES;
            self.pendingTableView.hidden=NO;
            
            for(NSDictionary *arrDict in resultArray)
            {
                CompletedModelClass *comp=[[CompletedModelClass alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([comp respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
                            [comp setValue:[arrDict valueForKey:key] forKey:key];
                        }else
                            [comp setValue:@"" forKey:key];
                    }
                }
                
                [pendingArray addObject:comp];
            }
        
            [self.pendingTableView reloadData];
            
        }else{
            self.pendingTableView.hidden=YES;
            self.loadingLabel.hidden=NO;
            [self.loadingLabel setText:@"No Challenges"];
        }
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    
}


@end
