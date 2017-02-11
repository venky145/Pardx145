//
//  FriendRequestViewController.m
//  Parodize
//
//  Created by Apple on 15/12/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "FriendRequestCell.h"

@interface FriendRequestViewController (){
    
    int selectedtag;
}

@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.requestArray);
    self.requestsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requestArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"FRCell";
    
    FriendRequestCell *cell=(FriendRequestCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendRequestCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *reqDict=[self.requestArray objectAtIndex:indexPath.row];
    
    cell.profileName.text=[NSString stringWithFormat:@"%@ %@",[reqDict objectForKey:@"firstname"],[reqDict objectForKey:@"lastname"]];
    
    NSString *thumbStr=[reqDict objectForKey:@"profilePicture"];
    
//    if (thumbStr.length>0) {
//        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:thumbStr];
//        cell.profileImage.image = [UIImage imageWithData:imageData];
//    }else{
//        cell.profileImage.image=[UIImage imageNamed:@"UserMale.png"];
//    }
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:thumbStr] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    [cell.acceptButton addTarget:self
               action:@selector(requestAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    cell.acceptButton.tag=indexPath.row;
    
    [cell.removeButton addTarget:self
               action:@selector(requestAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    cell.acceptButton.tag=indexPath.row;
    
    return cell;

}
-(void)requestAction:(UIButton *)button{
    
    selectedtag=button.tag;
    
    if ([button.titleLabel.text isEqualToString:@"Accept"]) {
        
        [self respondsToAction:@"True" withDict:[self.requestArray objectAtIndex:button.tag]];
        
    }else{
        [self respondsToAction:@"False" withDict:[self.requestArray objectAtIndex:button.tag]];
    }
}
-(void)respondsToAction:(NSString *)value withDict:(NSDictionary *)dict{

    NSDictionary* detailDict=[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"id"],@"id",value,@"accept", nil];
    [[DataManager sharedDataManager] friendRequestAccept:detailDict forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void)didPostFriendAccept:(NSMutableDictionary *) dataDictionary{
    
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
        [self.requestArray removeObjectAtIndex:selectedtag];
        [self.requestsTableView reloadData];
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

@end
