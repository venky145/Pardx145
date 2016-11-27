//
//  FreindDetailViewController.m
//  Parodize
//
//  Created by Apple on 11/11/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "FriendDetailViewController.h"

@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"%@",_friendObj);
    
//     [self getFriendDetails:[NSDictionary dictionaryWithObjectsAndKeys:[results objectForKey:@"first_name"],@"firstname",[results objectForKey:@"last_name"],@"lastname",[results objectForKey:@"email"],@"email",[results objectForKey:@"id"],@"fbid",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[results objectForKey:@"id"]],@"profilePictureURL", nil]];
    
    if (_friendObj.thumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:_friendObj.thumbnail];
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }else{
        self.profileImageView.image=[UIImage imageNamed:@"UserMale.png"];
    }

    
    self.friendName.text=[NSString stringWithFormat:@"%@ %@",_friendObj.firstname,_friendObj.lastname];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFriendDetails:(NSDictionary *)details{
    
    [[DataManager sharedDataManager] friendsDetails:details forSender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)followAction:(id)sender {
}

- (IBAction)challengeAction:(id)sender {
}

- (IBAction)addFriendAction:(id)sender {
}
@end
