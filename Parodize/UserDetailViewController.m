//
//  UserDetailViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 16/05/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "UserDetailViewController.h"
#import "Context.h"
#import <QuartzCore/QuartzCore.h>
#import "User_Profile.h"


@interface UserDetailViewController ()
{
    NSMutableDictionary* jsonDictionary;
    UIImage *selectedImage;
    UIImagePickerController *cameraPicker;
//    NSMutableDictionary* jsonDictionary;
}

@end

@implementation UserDetailViewController
@synthesize profileImage,firstName,lastName,aboutMe,saveButton,savedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[Context contextSharedManager]
                                 setBackgroundForView:self.view withImageName:@"City-Blue.jpg"];
    
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    
    firstName.layer.cornerRadius=2.0f;
    lastName.layer.cornerRadius=2.0f;
    aboutMe.layer.cornerRadius=2.0f;
    saveButton.layer.cornerRadius=2.0f;
    
    profileImage.layer.cornerRadius=4.0f;
    profileImage.layer.borderWidth=1.0f;
    profileImage.layer.borderColor=[UIColor whiteColor].CGColor;
    profileImage.layer.masksToBounds=YES;
    
    if (savedImage) {
        profileImage.image=savedImage;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [firstName becomeFirstResponder];
    
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
        
        
//        UIActionSheet *actionSheet;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Profile Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self openPhotoLibrary];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self openCamera];
            }]];
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        }
        else
        {
//            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture"
//                                                      delegate:self
//                                             cancelButtonTitle:@"Cancel"
//                                        destructiveButtonTitle:nil
//                                             otherButtonTitles:@"Photo Library", nil];
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Profile Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
               [self openPhotoLibrary];
            }]];

            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        }
        
//        actionSheet.tag=100;
//        
//        [actionSheet showInView:self.view];
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
//#pragma mark UIActionSheet Delegate
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (actionSheet.tag == 100) {
//        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo Library"])
//        {
//            [self openPhotoLibrary];
//        }
//        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open Camera"])
//        {
//            [self openCamera];
//        }
//    }
//    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
//}

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

- (void)saveImageInServer {
    
            [self showActivityInView:self.view.superview withMessage:@""];
            jsonDictionary=[[NSMutableDictionary alloc]init];
            
            // UIImage *image=[UIImage imageNamed:@"Name-100.png"];
            NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
            NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
            
            
            [jsonDictionary setValue:encodedString forKey:@"profilePicture"];
            
            
            [[DataManager sharedDataManager] updateProfilePicture:jsonDictionary forSender:self];
    
}


#pragma TWDataManagerDelegate  Methods

-(void) didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    [self hideActivity];
    
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionaray objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self updateUserInformation];
    }
}

-(void)updateUserInformation{
    jsonDictionary=[[NSMutableDictionary alloc]init];

    [jsonDictionary setValue:firstName.text forKey:@"firstname"];
    [jsonDictionary setValue:lastName.text forKey:@"lastname"];
    [jsonDictionary setValue:aboutMe.text forKey:@"about"];
    [jsonDictionary setValue:@"" forKey:@"phone"];
    [jsonDictionary setValue:@"" forKey:@"gender"];
    [jsonDictionary setValue:_usernameStr forKey:@"username"];
    
    [[DataManager sharedDataManager] updateInformation:jsonDictionary forSender:self];

}
- (IBAction)saveAction:(id)sender {
    
    if (self.firstName.text.length>0) {
        if (selectedImage) {
            
            [self saveImageInServer];
            
        }else{
            
            [self updateUserInformation];
            
        }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter first name" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    [self showActivityInView:self.view.superview withMessage:@""];

}
#pragma TWDataManagerDelegate  Methods

-(void) didInformationUpdated:(NSMutableDictionary *) dataDictionaray; {
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    [self hideActivity];
    if ([dataDictionaray objectForKey:RESPONSE_ERROR]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[dataDictionaray objectForKey:RESPONSE_ERROR] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self skipAction:nil];
    }
}
-(void) requestDidFailWithRequest:(NSError *)error{
    NSLog(@"Error");
    [self hideActivity];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Server internal issue, unable to communicate " preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    int limit = 100;
    return !([textField.text length]>limit && [string length] > range.length);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == firstName) {
        [textField resignFirstResponder];
        [lastName becomeFirstResponder];
    } else if (textField == lastName) {
        [textField resignFirstResponder];
        [aboutMe becomeFirstResponder];
    }else if (textField == aboutMe) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessSignUp" object:jsonDictionary];
    }];
}
@end
