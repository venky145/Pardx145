//
//  AcceptViewController.m
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "AcceptViewController.h"
#import "AcceptParodizeViewController.h"
#import "AcceptModelClass.h"
#import "AcceptCustomCell.h"

@interface AcceptViewController ()

@end

@implementation AcceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.challenges=[[NSMutableArray alloc]init];
    
    self.acceptTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    [self findAllChallenges];
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

-(void)findAllChallenges
{
//    PFQuery *query = [PFQuery queryWithClassName:@"Activity_table_new"];
//    [query whereKey:@"Recipient" equalTo:[PFUser currentUser].objectId];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %@ scores.", object);
//            // Do something with the found objects
////            for (PFObject *object in objects) {
////                NSLog(@"%@", object.objectId);
////            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
    [self.activityIndicator startAnimating];
    
    [self.statusLabel setText:@"Loading ..."];
    
    self.acceptTableView.hidden=YES;
    self.statusLabel.hidden=NO;
    self.activityIndicator.hidden=NO;
    
    
    [[DataManager sharedDataManager] requestAcceptChallenges:nil forSender:self];
    
}

#pragma mark UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.challenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"acceptCell";
    
     AcceptCustomCell *cell=(AcceptCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AcceptCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    AcceptModelClass *acceptModel=[self.challenges objectAtIndex:indexPath.row];
    
    cell.timeLabel.text=[[Context contextSharedManager] setDateInterval:acceptModel.time];
    
//    NSString *dateString = acceptModel.time;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    // this is imporant - we set our input date format to match our input string
//    // if format doesn't match you'll get nil from your string, so be careful
//    [dateFormatter setDateFormat:@"EEE MMM  dd hh:mm:ss yyyy"];
//    NSDate *dateFromString = [[NSDate alloc] init];
//    // voila!
//    dateFromString = [dateFormatter dateFromString:dateString];
//    
//    //NSDate *today = [NSDate new];
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    
//    BOOL isToday = [calendar isDateInToday:dateFromString];
//    BOOL isYesterday = [calendar isDateInYesterday:dateFromString];
//    
//    if (isToday) {
//        
//        cell.timeLabel.text =@"Today";
//    }
//    else if (isYesterday)
//    {
//        cell.timeLabel.text=@"Yesterday";
//    }else
//    {
//        cell.timeLabel.text=[dateFormatter stringFromDate:dateFromString];
//    }
    
    
    NSDictionary *emailDict=acceptModel.from;
    
    if ([emailDict objectForKey:@"firstname"]) {
        if ([emailDict objectForKey:@"lastname"]) {
            cell.challengeLabel.text=[NSString stringWithFormat:@"%@ %@ has challenged you!",[emailDict objectForKey:@"firstname"],[emailDict objectForKey:@"lastname"]];
        }
        else
            cell.challengeLabel.text=[NSString stringWithFormat:@"%@ has challenged you!",[emailDict objectForKey:@"firstname"]];
    }else{
        
        NSString *emailStr=[emailDict objectForKey:@"email"];
        
        NSArray *stringArray=[emailStr componentsSeparatedByString:@"@"];
        
        cell.challengeLabel.text=[NSString stringWithFormat:@"%@ has challenged you!",[stringArray objectAtIndex:0]];
    }
    cell.detailLabel.text=acceptModel.message;
    
    if ([emailDict objectForKey:@"thumbnail"] ){
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:[emailDict objectForKey:@"thumbnail"]];
        cell.userPic.image = [UIImage imageWithData:imageData];
    }else{
        cell.userPic.image=[UIImage imageNamed:@"UserMale.png"];
    }
    if (acceptModel.thumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:acceptModel.thumbnail];
        cell.mockImage.image = [UIImage imageWithData:imageData];
    }else{
        cell.mockImage.image=[UIImage imageNamed:@"UserMale.png"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AcceptCustomCell *cell=(AcceptCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    AcceptModelClass *acceptModel=[self.challenges objectAtIndex:indexPath.row];
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AcceptParodizeViewController *acceptView = [storyBoard instantiateViewControllerWithIdentifier:@"acceptParodize"];
    
    acceptView.getTimeStr=cell.timeLabel.text;
    acceptView.getmessageText=cell.detailLabel.text;
    acceptView.getId=acceptModel.id;
    
    if (acceptModel.thumbnail.length>0) {
        acceptView.acceptImage=acceptModel.thumbnail;
    }
    
    // completeView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:acceptView animated:YES];
    
}





- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma DataManagerDelegate  Methods

-(void) didGetAcceptedChallenges:(NSMutableDictionary *) dataDictionary {
    
    NSLog(@"Yahooooo... \n %@",dataDictionary);
    

    
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
        
        [self.activityIndicator stopAnimating];
        
        self.activityIndicator.hidden=YES;
        
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
        NSArray *challengeArray=[successDict objectForKey:@"challenge"];
        
        if (challengeArray.count>0) {
            self.statusLabel.hidden=YES;
             self.acceptTableView.hidden=NO;
        
            for(NSDictionary *arrDict in challengeArray)
            {
                AcceptModelClass *accept=[[AcceptModelClass alloc]init];
                
                for (NSString *key in arrDict) {
                    
                    NSLog(@"%@",[arrDict valueForKey:key]);
                    
                    if ([accept respondsToSelector:NSSelectorFromString(key)]) {
                        
                        if ([arrDict valueForKey:key] != NULL) {
                            [accept setValue:[arrDict valueForKey:key] forKey:key];
                        }else
                            [accept setValue:@"" forKey:key];
                    }
                }
                
                [self.challenges addObject:accept];
            }

            [_acceptTableView reloadData];
        }else
        {
            self.acceptTableView.hidden=YES;
            self.statusLabel.hidden=NO;
            [self.statusLabel setText:@"No Challenges"];
        }
        
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
    [self hideActivity];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Server internal issue, unable to communicate "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    
}

@end
