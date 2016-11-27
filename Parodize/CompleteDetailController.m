//
//  CompleteDetailController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "CompleteDetailController.h"

@interface CompleteDetailController ()

@end

@implementation CompleteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.twitterButton.layer.cornerRadius=25.0f;
    self.twitterButton.layer.masksToBounds=YES;
    
    
    
    if (self.completedModel.challengeThumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:self.completedModel.challengeThumbnail];
        self.originalImage.image = [UIImage imageWithData:imageData];
    }else{
        self.originalImage.image=[UIImage imageNamed:@"UserMale.png"];
    }
    
    if (self.completedModel.responseThumbnail.length>0) {
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:self.completedModel.responseThumbnail];
        self.mockImage.image = [UIImage imageWithData:imageData];
    }else{
        self.mockImage.image=[UIImage imageNamed:@"UserMale.png"];
    }
    
    
    
    
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

- (IBAction)twitterAction:(id)sender {
}

- (IBAction)fbAction:(id)sender {
}
@end
