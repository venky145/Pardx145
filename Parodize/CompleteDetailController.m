//
//  CompleteDetailController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "CompleteDetailController.h"
#import "ProfileImageController.h"

@interface CompleteDetailController ()

@end

@implementation CompleteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.twitterButton.layer.cornerRadius=25.0f;
    self.twitterButton.layer.masksToBounds=YES;
    
    [self.originalImage sd_setImageWithURL:[NSURL URLWithString:self.completedModel.challengeImage] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
//    if (self.completedModel.challengeThumbnail.length>0) {
//        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:self.completedModel.challengeThumbnail];
//        self.originalImage.image = [UIImage imageWithData:imageData];
//    }else{
//        self.originalImage.image=[UIImage imageNamed:@"UserMale.png"];
//    }
//    
//    if (self.completedModel.responseThumbnail.length>0) {
//        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:self.completedModel.responseThumbnail];
//        self.mockImage.image = [UIImage imageWithData:imageData];
//    }else{
//        self.mockImage.image=[UIImage imageNamed:@"UserMale.png"];
//    }
    
    [self.mockImage sd_setImageWithURL:[NSURL URLWithString:self.completedModel.responseImage] placeholderImage:[UIImage imageNamed:@"UserMale.png"]];
    
    UITapGestureRecognizer *challengeTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(challengeTouched:)];
    [challengeTap setNumberOfTapsRequired:1];
    [self.originalImage addGestureRecognizer:challengeTap];
    
    UITapGestureRecognizer *responseTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseTouched:)];
    [responseTap setNumberOfTapsRequired:1];
    [self.mockImage addGestureRecognizer:responseTap];
    
    
}

-(void)challengeTouched:(id)sender
{
    [self presentFullImage:self.originalImage.image];
}
-(void)responseTouched:(id)sender{
    [self presentFullImage:self.mockImage.image];
}
-(void)presentFullImage:(UIImage *)image{
    ProfileImageController *profileView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileImage"];
    
    profileView.profileData=image;
    
    profileView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    
    [self presentViewController:profileView animated:NO completion:nil];
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
