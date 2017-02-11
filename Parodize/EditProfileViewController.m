//
//  EditProfileViewController.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 10/06/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileCell.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat CONTENT_HEIGHT = 50;
static const CGFloat CONTENT_HEIGHT_iPhone4 = 200;

@interface EditProfileViewController ()
{
    NSArray *placeholderArray;
    NSArray *genderArray;
    NSMutableDictionary *textFieldsDict;
    
    NSString *genderStr;
    
    //
    
    BOOL           keyboardVisible;
    CGPoint        offset;
    CGFloat animatedDistance;
    NSIndexPath *nextIndexPath;
    
    UITextField *previousTextField;
    
    //
    UIImage *selectedImage;
    UIImagePickerController *cameraPicker;
    
    BOOL isInfoChanged;
    
    NSString *copyGender;
}

@end

@implementation EditProfileViewController

@synthesize getImage,editUserProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    textFieldsDict=[[NSMutableDictionary alloc]init];
    placeholderArray=[NSArray arrayWithObjects:@"FirstName",@"LastName",@"About",@"Phone",@"Gender",nil];

    genderArray=[NSArray arrayWithObjects:@"Male",@"Female", nil];
    
    self.profileImage.image=getImage;
    
    self.editTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.profileImage.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileImage:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImage addGestureRecognizer:singleTap];
    
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    
    self.doneButton.enabled=NO;
    
    [self.genderPicker setHidden:YES];
    
    if ([editUserProfile.gender isEqualToString:@"F"]) {
        genderStr=@"Female";
    }else if ([editUserProfile.gender isEqualToString:@"M"]){
        genderStr=@"Male";
    }
    if (genderStr.length>0) {
        copyGender=genderStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //self.profileImage.layer.opaque = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height >= 568.0f)
            self.editTableView.contentSize=CGSizeMake(self.editTableView.frame.size.width, self.editTableView.frame.size.height+CONTENT_HEIGHT);
        else
            self.editTableView.contentSize=CGSizeMake(self.editTableView.frame.size.width, self.editTableView.frame.size.height+CONTENT_HEIGHT_iPhone4);
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditProfileCell *cell = [self.editTableView cellForRowAtIndexPath:indexPath];
    
    [cell.detailText becomeFirstResponder];
    
}
-(void)viewDidLayoutSubviews
{
    [[Context contextSharedManager] roundImageView:self.profileImage];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 60;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return placeholderArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"editCell";
    
        EditProfileCell *cell = (EditProfileCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[EditProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.detailText.tag=indexPath.row;
        cell.detailText.placeholder=[placeholderArray objectAtIndex:indexPath.row];
    
        if (indexPath.row==0) {
            
            cell.detailText.text=editUserProfile.firstname;
            
        }else if (indexPath.row==1) {
            cell.detailText.text=editUserProfile.lastname;
            
        }else if (indexPath.row==2) {
            cell.detailText.text=editUserProfile.about;
            
        }else if (indexPath.row==3) {
            cell.detailText.keyboardType=UIKeyboardTypeNumberPad;
            cell.detailText.text=editUserProfile.phone;
            
        }else if (indexPath.row==4) {
                cell.detailText.text=genderStr;
        }

    
    NSLog(@"%@",cell.detailText);
    
        [textFieldsDict setObject:cell.detailText forKey:[[placeholderArray objectAtIndex:indexPath.row] lowercaseString]];
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)editProfileImage:(id)sender
{
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
        if (selectedImage||getImage)
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [actionSheet dismissViewControllerAnimated:YES completion:nil];
                selectedImage=nil;
                self.profileImage.image=[UIImage imageNamed:@"user_image"];
                
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
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
//    if (textField.tag == 3) {
//        
//        [self doneAction:nil];
//        
//    }else
//    {
    
        EditProfileCell *currentCell = (EditProfileCell *) textField.superview.superview;
        NSIndexPath *currentIndexPath = [self.editTableView indexPathForCell:currentCell];
        
        // NSIndexPath *currentIndexPath = [self.contactTableView indexPathForSelectedRow];
        
        nextIndexPath = [self nextIndexPath:currentIndexPath];
        EditProfileCell *nextCell = [self.editTableView cellForRowAtIndexPath:nextIndexPath];
        
        
        
        [nextCell.detailText becomeFirstResponder]; //or whatever your property is called

//    }

    
    
    return YES;
    
}
- (NSIndexPath *) nextIndexPath:(NSIndexPath *) indexPath {
    int numOfSections = 1;
    int nextSection = ((0 + 1) % numOfSections);
    
    if ((indexPath.row +1) == [self tableView:self.editTableView numberOfRowsInSection:indexPath.section]) {
        return [NSIndexPath indexPathForRow:0 inSection:nextSection];
    } else {
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Editing begins");
    if (textField.tag!=4) {
        [self.genderPicker setHidden:YES];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"character changing");
    
    self.doneButton.enabled=YES;
    
    isInfoChanged=YES;
    
    if (textField.tag==3) {
        NSInteger length = [textField.text length];
        if (length>9 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>10) {
                textField.text = [textField.text substringToIndex:10];
                
            }
        });
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"tag %ld",(long)textField.tag);
    
//    if (previousTextField==nil)
//    {
//        previousTextField=textField;
//    }
//    if (textField.tag==3)
//        textField.returnKeyType = UIReturnKeyDone;
//    else
        if (textField.tag==4){
            [previousTextField resignFirstResponder];
            previousTextField=textField;
        [self.genderPicker setHidden:NO];
        return NO;
    }
    
    else
        previousTextField=textField;
        textField.returnKeyType=UIReturnKeyNext;
    

    return YES; //show keyboard
}
#pragma mark UIImagePickerViewcontroller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    selectedImage = chosenImage;
    self.profileImage.image=selectedImage;
    
    self.doneButton.enabled=YES;
    
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
- (IBAction)doneAction:(id)sender {
    [self.view endEditing:YES];
    
    if (isInfoChanged) {
        if ([self validateAllTextFields]) {
            [self showActivityInView:self.view.superview withMessage:@""];
            
            if (selectedImage) {
                
                [self uploadImage];
            }else
            {
                [self uploadInformation];
            }
            
        }
    }else{
        if (selectedImage) {
            
            [self showActivityInView:self.view.superview withMessage:@""];
            
            [self uploadImage];
        }
    }
    
    
}
-(void)uploadImage
{
        NSMutableDictionary* jsonDictionary=[[NSMutableDictionary alloc]init];
        
        // UIImage *image=[UIImage imageNamed:@"Name-100.png"];
        NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
        NSString *encodedString =  [imageData base64EncodedStringWithOptions:0];
        
        [jsonDictionary setValue:encodedString forKey:@"profilePicture"];
        
        [[DataManager sharedDataManager] updateProfilePicture:jsonDictionary forSender:self];
}
-(void)uploadInformation
{
    
    NSDictionary* jsonDictionary=[[NSMutableDictionary alloc]init];
    
    for (NSString *key in placeholderArray) {
        
        UITextField *dataText=[textFieldsDict objectForKey:[key lowercaseString]];
        
        [jsonDictionary setValue:dataText.text forKey:[key lowercaseString]];
        
        NSLog(@"test %@ --- key %@",dataText.text,[key lowercaseString]);
        
    }
    [[DataManager sharedDataManager] updateInformation:jsonDictionary forSender:self];
}
-(BOOL)validateAllTextFields
{
    for (NSString *key in placeholderArray) {
        UITextField *dataText=[textFieldsDict objectForKey:[key lowercaseString]];
        
        if (![key isEqualToString:@"About"])
        {
            if (![key isEqualToString:@"Phone"]) {
                if (dataText.text.length==0){
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                    message:[NSString stringWithFormat:@"Please enter %@",key]
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                    [alert show];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Please enter %@",key] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];

                    
                    return NO;
                }

            }else{
                if (!(dataText.text.length==10)) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Phone Number" message:@"Please enter 10 digit phone number" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return NO;
                }
                
            }
        }
    }
    
    return YES;
}
#pragma mark UIPicker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [genderArray objectAtIndex: row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (row==0) {
        genderStr=@"Male";
    }else
        genderStr=@"Female";
    
    if (![genderStr isEqualToString:copyGender]) {
        self.doneButton.enabled=YES;
        isInfoChanged=YES;
    }
    [self.genderPicker setHidden:YES];
    [self.editTableView reloadData];
    
    
}
#pragma TWDataManagerDelegate  Methods

-(void) didProfileImageUpdated:(NSMutableDictionary *) dataDictionaray; {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    //[self hideActivity];
    
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
        if (isInfoChanged) {
            
            [self uploadInformation];
        }else
        {
            [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
        }
        
    }
}
#pragma TWDataManagerDelegate  Methods

-(void) didInformationUpdated:(NSMutableDictionary *) dataDictionaray; {
    
    NSLog(@"Yahooooo... \n %@",dataDictionaray);
    
    //[self hideActivity];
    
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
        
             [[DataManager sharedDataManager] requestProfileDetails:nil forSender:self];
        
    }
}
-(void) didGetProfileDetails:(NSMutableDictionary *) dataDictionaray
{
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
        
        NSMutableDictionary *responseDict=[[dataDictionaray valueForKey:RESPONSE_SUCCESS] mutableCopy];
        
        
        
        [responseDict removeObjectForKey:@"notifications"];
        
        [User_Profile saveUserProfile:responseDict withCompletionBlock:^(BOOL flag,NSString *firstName,NSString *lastName,NSString *email) {
            if (flag)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_UPDATE object:responseDict];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                NSLog(@"Database storage error");
            }
        }];
        
        
        
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

@end
