//
//  SignUpViewController.m
//  Parodize
//
//  Created by administrator on 25/10/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "SignUpViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "ActivityBaseViewController.h"

@interface SignUpViewController ()
{
    UIImagePickerController *cameraPicker;
}

@end

@implementation SignUpViewController

@synthesize cameraButton,profileImage,activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    profileImage.layer.cornerRadius=2.0f;
    profileImage.layer.borderWidth=1.0f;
    profileImage.layer.borderColor=[UIColor blueColor].CGColor;
    profileImage.layer.masksToBounds=YES;
    
    cameraPicker = [[UIImagePickerController alloc] init];
    
    activityIndicator.hidden=YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUpAction:(id)sender
{
    
    if (profileImage.image==nil)
    {
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Picture" message:@"Do you want to continue without profile picture" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesAlert = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           //Do some thing here
                                           [self doSignUpProcess];
                                           
                                       }];
            [alertController addAction:yesAlert];
            UIAlertAction* noAlert = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                      {
                                          //Do some thing here
                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
            [alertController addAction:noAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No Picture" message:@"Do you want to continue without profile picture" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            
            [alert show];
            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Picture" message:@"Do you want to continue without profile picture" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:ok];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }

    }
    else
    {
        [self doSignUpProcess];
    }
}

- (IBAction)cancelAction:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)doSignUpProcess
{
    activityIndicator.hidden=NO;
    [activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *emailString = self.emailText.text; // storing the entered email in a string.**
    // Regular expression to checl the email format.**
    
    NSString* emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    //  BOOL isValid=[emailTest evaluateWithObject:emailString];
    
    if (!self.userNameText.text.length || !self.emailText.text.length || !self.passwordText.text.length || !self.confirmPasswordText.text.length ||  ([emailTest evaluateWithObject:emailString] == YES))
    {
        
        
        if ([self.passwordText.text isEqualToString:self.confirmPasswordText.text])
        {
            
        }
        else
        {
            activityIndicator.hidden=YES;
            
            [activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            UIAlertView *passAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check Password and Confirm password should be same" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [passAlert show];
        }
    }
    else
    {
        activityIndicator.hidden=YES;
        
        [activityIndicator stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        UIAlertView *fieldsAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [fieldsAlert show];
    }
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
        if (profileImage.image)
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [actionSheet dismissViewControllerAnimated:YES completion:nil];
                    profileImage.image=nil;

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
    profileImage.image = chosenImage;
    
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
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)openPhotoLibrary
{
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}
-(void)openCamera
{
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
