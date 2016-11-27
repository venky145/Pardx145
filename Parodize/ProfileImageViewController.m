//
//  ProfileImageViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "ProfileImageViewController.h"
#import "UserDetailViewController.h"
#import "Context.h"
#import <QuartzCore/QuartzCore.h>
#import "User_Profile.h"

@interface ProfileImageViewController ()
{
    UIImage *selectedImage;
    UIImagePickerController *cameraPicker;
    NSMutableDictionary* jsonDictionary;
}

@end

@implementation ProfileImageViewController

@synthesize profileImage,profileView,saveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[Context contextSharedManager]
                                 setBackgroundForView:self.view withImageName:@"City-Blue.jpg"];
    
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    
    saveButton.layer.cornerRadius=4.0f;
    profileView.layer.cornerRadius=4.0f;
    profileView.layer.borderWidth=1.0f;
    profileView.layer.borderColor=[UIColor whiteColor].CGColor;
    profileView.layer.masksToBounds=YES;
    
    saveButton.enabled=NO;
    saveButton.alpha=0.5;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationItem setHidesBackButton:YES animated:NO];
}
- (IBAction)cameraAction:(id)sender {
    
    if ([UIAlertController class])
    {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Profile Picture" message:@"Choose from photo library (or) Take a snap" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped.
            [actionSheet dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Photo Library button tapped.
            [actionSheet dismissViewControllerAnimated:YES completion:nil];
            [self openPhotoLibrary];
            
            
        }]];
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                // Open Camera button tapped.
                
                [actionSheet dismissViewControllerAnimated:YES completion:nil];
                
                [self openCamera];
            }]];
        }
        if (selectedImage)
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [actionSheet dismissViewControllerAnimated:YES completion:nil];
                selectedImage=nil;
                profileImage.image=[UIImage imageNamed:@"user_image"];
                
            }]];
        }
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Photo Library", @"Open Camera", nil];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Photo Library", nil];
        }
        
        actionSheet.tag=100;
        
        [actionSheet showInView:self.view];
    }

}
#pragma mark UIImagePickerViewcontroller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    selectedImage = chosenImage;
    profileImage.image=selectedImage;
    
    saveButton.alpha=1;
    saveButton.enabled=YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo Library"])
        {
            [self openPhotoLibrary];
        }
        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open Camera"])
        {
            [self openCamera];
        }
    }
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)openPhotoLibrary
{
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}
-(void)openCamera
{
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}

- (IBAction)saveAction:(id)sender {
    
    if (selectedImage) {

        [self showActivityInView:self.view.superview withMessage:@""];
        jsonDictionary=[[NSMutableDictionary alloc]init];
        
        // UIImage *image=[UIImage imageNamed:@"Name-100.png"];
        NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
        NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
        
        
        [jsonDictionary setValue:encodedString forKey:@"profilePicture"];
       /* NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseAPI,PROFILE_PICTURE]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"] forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:jsonData];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
            [self hideActivity];
        }*/
        
        [[DataManager sharedDataManager] updateProfilePicture:jsonDictionary forSender:self];

    }
}


#pragma TWDataManagerDelegate  Methods

-(void) didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    [self hideActivity];
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dataDictionaray objectForKey:RESPONSE_ERROR]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
//        [User_Profile saveUserProfile:jsonDictionary withCompletionBlock:^(BOOL flag) {
//            if (flag)
//            {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UserDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"userDetail"];
                    vc.savedImage=selectedImage;
                    [self.navigationController pushViewController:vc animated:YES];
//            }
//            else
//            {
//                NSLog(@"Database storage error");
//            }
//        }];
        
        
        
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


//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
//    
//    NSLog(@"%@",data);
//    
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    SBJsonParser *parser=[[SBJsonParser alloc]init];
//    
//    NSDictionary *dict=[parser objectWithData:data];
//    
//    if ([[dict allKeys]containsObject:@"errors"]) {
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[dict objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    }else{
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        UserDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"userDetail"];
//        vc.savedImage=selectedImage;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
//    
//    [self hideActivity];
//}
//
//// This method receives the error report in case of connection is not made to server.
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
//    [self hideActivity];
//}
//
//// This method is used to process the data after connection has made successfully.
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSLog(@"Success");
//}
- (IBAction)skipAction:(id)sender {
    
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
    
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        
        UserDetailViewController *userDetail=segue.destinationViewController;
        
        
    }
}

@end
