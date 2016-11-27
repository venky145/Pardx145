//
//  CompletedViewController.m
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "CompletedViewController.h"
#import "AcceptSendViewController.h"
#import "PendingCell.h"
#import "CompletedCell.h"
#import "CompleteDetailController.h"

@interface CompletedViewController ()

@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    completedArray=[[NSMutableArray alloc]init];
    
    pendingArray=[[NSMutableArray alloc]init];
    
    [self getCompletedChallenges];
}

-(void)getCompletedChallenges
{
    [self.activityIndicator startAnimating];
    
    [self.statusLabel setText:@"Loading ..."];
    
    self.completedTableView.hidden=YES;
    self.statusLabel.hidden=NO;
    self.activityIndicator.hidden=NO;
    
    [[DataManager sharedDataManager] requestCompletedChallenges:nil forSender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
       return pendingArray.count;
    }
    else if(section==1)
    {
        return completedArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        if (pendingArray.count>0) {
            
            return @"Pending";
        }else
        {
            return @"No Pending Challenges";
        }
        
    }else if(section == 1)
    {
        if (completedArray.count>0) {
            
            return @"Completed";
        }else
        {
            return @"No Completed Challenges";
        }

    }
    return nil;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    
    CompletedModelClass *completeModel=nil;
    
    if (indexPath.section==0)
    {
        cellIdentifier=@"pendingCell";
        
        completeModel=[pendingArray objectAtIndex:indexPath.row];
        
        PendingCell *cell=(PendingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.pendingLabel.text=@"Your challenge is pending responses";
        
        if (completeModel.message.length>0) {
            cell.messageText.text=completeModel.message;
        }else
        {
            cell.messageText.text=@"No message";
        }
        
        
        if (completeModel.challengeThumbnail.length>0) {
            NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:completeModel.challengeThumbnail];
            cell.mockImage.image = [UIImage imageWithData:imageData];
        }else{
            cell.mockImage.image=[UIImage imageNamed:@"UserMale.png"];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else if (indexPath.section==1)
    {
        cellIdentifier=@"completedCell";
        
        completeModel=[completedArray objectAtIndex:indexPath.row];
        
        CompletedCell *cell=(CompletedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CompletedCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
//        cell.profileImage
        
         NSDictionary *userDict=completeModel.from;
        
        cell.textDesc.text=[NSString stringWithFormat:@"%@ challenged you",[userDict objectForKey:@"firstname"]];
        cell.messagelabel.text=completeModel.message;
        
        if ([userDict objectForKey:@"thumbnail"]) {
            NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:[userDict objectForKey:@"thumbnail"]];
            cell.profileImage.image = [UIImage imageWithData:imageData];
        }else{
            
            cell.profileImage.image=[UIImage imageNamed:@"UserMale.png"];
        }
        
        if (completeModel.challengeThumbnail.length>0) {
            NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:completeModel.challengeThumbnail];
            cell.mockImage.image = [UIImage imageWithData:imageData];
        }else{
            cell.mockImage.image=[UIImage imageNamed:@"UserMale.png"];
        }
        
        if (completeModel.message.length>0) {
            cell.messagelabel.text=completeModel.message;
        }else
        {
            cell.messagelabel.text=@"No message";
        }
        
        cell.timeLabel.text=[[Context contextSharedManager] setDateInterval:completeModel.time];
        
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath]
    
    if (indexPath.section==1) {
        
        self.modelClass=[completedArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"completeSegue" sender:self];
        
    }
    
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"completeSegue"]) {
        
        CompleteDetailController *destViewController = segue.destinationViewController;
        
        destViewController.completedModel=self.modelClass;
       
    }
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma DataManagerDelegate  Methods

-(void) didGetCompletedChallenges:(NSMutableDictionary *) dataDictionary {
    
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
        
        NSArray *compArray=[successDict objectForKey:@"completed"];
        NSArray *pendArray=[successDict objectForKey:@"pending"];
        
        if (compArray.count>0||pendArray.count>0) {
            
            self.statusLabel.hidden=YES;
            self.completedTableView.hidden=NO;
            
            for(NSDictionary *arrDict in pendArray)
            {
                CompletedModelClass *pend=[[CompletedModelClass alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([pend respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
                            [pend setValue:[arrDict valueForKey:key] forKey:key];
                        }else
                            [pend setValue:@"" forKey:key];
                    }
                }
                
                [pendingArray addObject:pend];
            }
            for(NSDictionary *arrDict in compArray)
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
                
                [completedArray addObject:comp];
            }
            
            [self.completedTableView reloadData];
            
        }else
        {
            self.completedTableView.hidden=YES;
            self.statusLabel.hidden=NO;
            [self.statusLabel setText:@"No Challenges"];
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
