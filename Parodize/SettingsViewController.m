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


@interface SettingsViewController ()

{
    NSMutableArray *settingsArray;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    settingsArray=[[NSMutableArray alloc]initWithObjects:@"Location",@"Notifications",@"Linked Accounts",@"Block", nil];
    
    self.title=@"Settings";
}
#pragma mark UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return settingsArray.count;
    }else if(section==1){
        
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
    if (indexPath.section==1) {
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
