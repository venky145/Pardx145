//
//  NotificationViewController.m
//  Parodize
//
//  Created by Apple on 29/06/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController (){
    NSMutableArray *soundsArray;
    NSMutableArray *soundsTitleArray;
    NSMutableArray *notificationTypeArray;
    NotificationObject *nObj;
    UITableViewCell *prevCell;
    
    
    NSIndexPath *selectedIndex;
    
    UIBarButtonItem *doneButton;
    
    NSIndexSet *indexSet;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    soundsTitleArray = [[NSMutableArray alloc]initWithObjects:@"Calypso",@"Ladder",nil];
    soundsArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:1322],[NSNumber numberWithInt:1326], nil];
    notificationTypeArray = [[NSMutableArray alloc]initWithObjects:@"Challenge",@"Like",@"Poke",@"Response",nil];
    
    doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSettingsAction:)];
    
    self.navigationItem.rightBarButtonItem=doneButton;
    
    self.title=@"Notifications";
    
    nObj = [[NotificationObject alloc]init];

    nObj.challenge=_notifications.challenge;
    nObj.poke=_notifications.poke;
    nObj.like=_notifications.like;
    nObj.response=_notifications.response;
    
    indexSet = [NSIndexSet indexSetWithIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"When to show";
    }else{
        
        return @"Sounds";
    }
    
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section==0) {
        return notificationTypeArray.count;
    }else{
        return soundsTitleArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
//        NSString* cellIdentifier=@"notifyCell";
//        
//        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell==nil)
//        {
//            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//            
//            
//        }
//        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
//        cell.accessoryView = switchView;
//        switchView.on=YES;
//        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        return cell;
//    }else if(indexPath.section==1){
        NSString* cellIdentifier=@"listCell";
        
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil)
        {
            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            
            
        }
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        switchView.on=NO;
        [switchView addTarget:self action:@selector(listSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        switchView.tag=indexPath.row;
        if (indexPath.row==0) {
            
            if (_notifications.challenge==0) {
                switchView.on = NO;
            }else{
                switchView.on = YES;
            }
            
        }else if (indexPath.row==1) {
            if (_notifications.like==0) {
                switchView.on = NO;
            }else{
                switchView.on = YES;
            }
            
        }else if (indexPath.row==2) {
            if (_notifications.poke==0) {
                switchView.on = NO;
            }else{
                switchView.on = YES;
            }
            
        }else if (indexPath.row==3) {
            if (_notifications.response==0) {
                switchView.on = NO;
            }else{
                switchView.on = YES;
            }
        }
        
        cell.textLabel.text=notificationTypeArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexPath.section==1){
        NSString* cellIdentifier=@"soundCell";
        
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil)
        {
            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = soundsTitleArray[indexPath.row];
        
        if (indexPath == selectedIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            selectedIndex = nil;
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectedIndex = indexPath;
            [tableView beginUpdates];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }
    }
}
- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}
- (void)listSwitchChanged:(id)sender {
    
//    NotificationObject *nObj = [[NotificationObject alloc]init];
    
    UISwitch *switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    int value = switchControl.on ? 1 : 0 ;
    
    if (switchControl.tag==0) {
        
        _notifications.challenge=value;
        
    }else if (switchControl.tag==1){
        
        _notifications.like=value;
        
    }else if (switchControl.tag==2){
        
        _notifications.poke=value;
        
    }else if (switchControl.tag==3){
        
        _notifications.response=value;
        
    }
    
    [self updateSettings];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 }

-(void)updateSettings{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,SETTINGS];
    
    NSDictionary *notifDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_notifications.challenge],@"challenge",[NSNumber numberWithInt:_notifications.like],@"like",[NSNumber numberWithInt:_notifications.poke],@"poke",[NSNumber numberWithInt:_notifications.response],@"response",nil];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_settingObj.notifSound,@"notifSound",[NSNumber numberWithInt:_settingObj.privateProfile],@"privateProfile",[NSNumber numberWithInt:_settingObj.profileVisibility],@"profileVisibility",notifDict,@"notifications",nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else{
            
//            NSDictionary *successDict=[data objectForKey:@"success"];
        }
    }];
}

-(void)deactiveAccount{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,DEACTIVATE_ACCOUNT];
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:nil postTypeMethod:eGET headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else{
            
//            NSDictionary *successDict=[data objectForKey:@"success"];
        }
    }];

}
-(void)doneSettingsAction:(id)sender{
    
}
@end
