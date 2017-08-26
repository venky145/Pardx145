//
//  SettingsViewController.m
//  Parodize
//
//  Created by Apple on 22/01/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "SettingsDeleteCell.h"
#import "NotificationObject.h"
#import "SettingsObject.h"


@interface SettingsViewController ()

{
    NSMutableArray *settingsArray;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    settingsArray=[[NSMutableArray alloc]initWithObjects:@"Location",@"Notifications",@"Account",@"Support",@"About", nil];
    
    self.title=@"Settings";
    
    self.sObj = [[SettingsObject alloc]init];
    
    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
    
    [self fetchSettings];
}
-(void)fetchSettings
{
    
    [self showActivityWithMessage:nil];
    
    NSUserDefaults *sharedUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseAPI,SETTINGS];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"",nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:eGET headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [self hideActivity];
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else{
            
            NSDictionary *successDict=[data objectForKey:@"success"];
            
            [sharedUserDefaults setValue:successDict forKey:SETTINGS_DEFAULT];
            [sharedUserDefaults synchronize];
        
            for (NSString *key in successDict) {
                if ([self.sObj respondsToSelector:NSSelectorFromString(key)]) {
                    
                    if ([successDict valueForKey:key] != NULL) {
                        
                        if ([key isEqualToString:@"notifications"]) {
                            NSDictionary *notifDict = [successDict valueForKey:key];
                            NotificationObject *nObj = [[NotificationObject alloc]init];
                            for (NSString *key in notifDict) {
                                if ([nObj respondsToSelector:NSSelectorFromString(key)]) {
                                    
                                    if ([notifDict valueForKey:key] != NULL) {
                                        [nObj setValue:[notifDict valueForKey:key] forKey:key];
                                    }else{
                                         [nObj setValue:@"" forKey:key];
                                    }
                                }
                            }
                            [self.sObj setValue:nObj forKey:key];
                        }else{
                            [self.sObj setValue:[successDict valueForKey:key] forKey:key];
                        }
                    }
                    else
                        [self.sObj setValue:@"" forKey:key];
                }
            }
            
            NSLog(@"%@",self.sObj);
            
            [self hideActivity];
            
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
}
#pragma mark UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return settingsArray.count;
    }else if(section==1){
        
        return 1;
    }else if(section==2){
        
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        NSString* cellIdentifier;
        if (indexPath.row==0) {
            
            cellIdentifier=@"SettingsCell";
            SettingsCell *cell=(SettingsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell==nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell=[nib objectAtIndex:0];
            }

            [cell.locationSwitch addTarget:self action:@selector(turnOffLocation:) forControlEvents:UIControlEventTouchUpInside];
            
                //cell.textLabel.text=[settingsArray objectAtIndex:indexPath.row];
                //cell.accessoryType=UITableViewCellAccessoryNone;
            
            return cell;
            
        }else{
            
            cellIdentifier=@"cellIdentifier";
            UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell==nil)
            {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
               
            }
            
            cell.textLabel.text=[settingsArray objectAtIndex:indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }

    }else if(indexPath.section==1){
        NSString *cacheIdentifier=@"cacheCell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cacheIdentifier];
        
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cacheIdentifier];
            
        }
        
//        cell.textLabel.text=[settingsArray objectAtIndex:indexPath.row];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.section==2){
        NSString* deleteIdentifier=@"LogoutCell";
        
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:deleteIdentifier];
        
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:deleteIdentifier];
            
        }
        
        //cell.textLabel.text=DELETE_ACCOUNT;
        return cell;
    }else if(indexPath.section==3){
        NSString* deleteIdentifier=@"DeleteCell";
        
        UITableViewCell *cell=(SettingsDeleteCell *)[tableView dequeueReusableCellWithIdentifier:deleteIdentifier];
        
        if (cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:deleteIdentifier owner:self options:nil];
            //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell=[nib objectAtIndex:0];
        }
        
        //cell.textLabel.text=DELETE_ACCOUNT;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [self performSegueWithIdentifier:@"notificationSegue" sender:self];
        }
        
    }else if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Cache"
                                          message:@"Do you want to clear cache"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Clear"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         SDImageCache *imageCache = [SDImageCache sharedImageCache];
                                         [imageCache clearMemory];
                                         [imageCache clearDisk];
                                         
                                     }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}
-(void)turnOffLocation:(UISwitch *)locationSwitch{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"notificationSegue"]) {
        //[self.picker dismissViewControllerAnimated:NO completion:nil];
        
        NotificationViewController *notificationViewController = segue.destinationViewController;
        notificationViewController.notifications = self.sObj.notifications;
        notificationViewController.settingObj = self.sObj;
    }
    
}


@end
