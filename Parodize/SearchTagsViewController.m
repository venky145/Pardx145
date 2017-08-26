//
//  SearchTagsViewController.m
//  Parodize
//
//  Created by Apple on 17/04/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "SearchTagsViewController.h"
#import "SearchTagObject.h"
#import "TagDetailViewController.h"
#import "Tags+CoreDataClass.h"


@interface SearchTagsViewController ()
{
    
    NSMutableArray *tagsArray;
    
    SearchTagObject *searchTagObj;
    
    NSArray *sugTagsArray;
    
}

@end

@implementation SearchTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tagsArray = [[NSMutableArray alloc]init];
    
    _tagsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _noTagsLabel.hidden=YES;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    sugTagsArray = [Tags fetchTagDetails:@"Tags"];
    
    if (sugTagsArray.count>0) {
        [_tagsTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"tagDetail"]) {
        
        //        AcceptSendViewController *destViewController = segue.destinationViewController;
        //        destViewController.getImage = stillImage;
        //        destViewController.acceptID = self.getId;
        //        destViewController.getMockImage=self.acceptImageView.image;
        //        destViewController.isAccept = YES;
        
        TagDetailViewController *tagView = segue.destinationViewController;
        tagView.tagObject=searchTagObj;
        
    }
}


#pragma mark UISearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//        self.searchBar.showsCancelButton=YES;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length>0) {
        [self searchTagsWithStr:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//        self.searchBar.showsCancelButton=NO;
//        [self.searchBar resignFirstResponder];
}
-(void)searchTagsWithStr:(NSString *)searchStr{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",pgBASE_API,PG_SUGGEST];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:searchStr,@"string", nil];
    
    NSDictionary *userInfo = @{
                               @"postdata": dict
                               };
    
    [[Context contextSharedManager] pgfetchDataForURL:urlStr userInfo:userInfo postTypeMethod:ePOST headerAutherization:YES withCompletionHandler:^(NSDictionary *data, NSError *error) {
        NSLog(@"%@",data);
        
        if ([data objectForKey:RESPONSE_ERROR]) {
            
            [[Context contextSharedManager] showAlertView:self withMessage:[data objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        }
        else
        {
            NSArray *successArray=[data objectForKey:@"success"];
            
            [tagsArray removeAllObjects];
            
            if (successArray.count>0) {
                _noTagsLabel.hidden=YES;
                _tagsTableView.hidden=NO;
                
                for (NSDictionary *searchDict in successArray) {
                    
                    SearchTagObject *tagObj = [[SearchTagObject alloc]init];
                    
                    for (NSString *key in searchDict) {
                        
                        // NSLog(@"%@",[arrDict valueForKey:key]);
                        
                        if ([tagObj respondsToSelector:NSSelectorFromString(key)]) {
                            
                            if ([searchDict valueForKey:key] != NULL) {
                                [tagObj setValue:[searchDict valueForKey:key] forKey:key];
                            }else{
                                [tagObj setValue:@"" forKey:key];
                            }
                        }
                    }
                    
                    [tagsArray addObject:tagObj];
                }
            }else{
                _noTagsLabel.hidden=NO;
                _tagsTableView.hidden=YES;
            }
            
            [_tagsTableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tagsArray.count>0) {
        return tagsArray.count;
    }else{
        return sugTagsArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier=@"tagsCell";
    
    
    UITableViewCell  *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    if (tagsArray.count>0) {
        SearchTagObject *tagObj = [tagsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text=[NSString stringWithFormat:@"# %@",tagObj.tag];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ challenges",tagObj.posts];
    }else{
        
        Tags* tagData = [sugTagsArray objectAtIndex:indexPath.row];
     
        cell.textLabel.text=[NSString stringWithFormat:@"# %@",tagData.tag];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ challenges",tagData.posts];
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tagsArray.count>0) {
        searchTagObj = [tagsArray objectAtIndex:indexPath.row];
        NSDictionary *searchDict = [NSDictionary dictionaryWithObjectsAndKeys:searchTagObj.id,@"id",searchTagObj.posts,@"posts",searchTagObj.tag,@"tag",nil];
        [Tags saveTagDetails:searchDict withCompletionBlock:^(BOOL flag, NSNumber * _Nonnull id, NSNumber * _Nonnull posts, NSString * _Nonnull tag) {
            
        }];
    }else{
        
        
        
        searchTagObj=[[SearchTagObject alloc]init];
        Tags* tagData = [sugTagsArray objectAtIndex:indexPath.row];
        searchTagObj.id=tagData.id;
        searchTagObj.posts=tagData.posts;
        searchTagObj.tag=tagData.tag;
    }
    

//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    TagDetailViewController *newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"tagDetail"];
//    newViewController.tagObject=tagObj;
//    
//    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:newViewController];
//    
//    [self presentViewController:newNavigation animated:NO completion:nil];
    
    [self performSegueWithIdentifier:@"tagDetail" sender:self];
    
    
}
- (IBAction)cancelAction:(id)sender {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
