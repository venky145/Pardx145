//
//  CamOverlayViewController.m
//  Parodize
//
//  Created by administrator on 17/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import "CamOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CamOverlayViewController ()

@end

@implementation CamOverlayViewController

@synthesize cameraButton,imagePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cameraButton.layer.cornerRadius=cameraButton.frame.size.height/2;
    cameraButton.layer.borderWidth=2.0f;
    cameraButton.layer.borderColor=[UIColor whiteColor].CGColor;
    cameraButton.layer.masksToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"imageDone");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Done");
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)snapShotAction:(id)sender {
    
    [imagePicker takePicture];
    
}

- (IBAction)camRotate:(id)sender {
}

- (IBAction)camFlash:(id)sender {
}
@end
