//
//  AcceptCaptionViewController.m
//  Parodize
//
//  Created by Apple on 27/05/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "AcceptCaptionViewController.h"
#import "AcceptSendViewController.h"
#import "AppDelegate.h"

@interface AcceptCaptionViewController (){
    
    AppDelegate *appDelegate;
}

@end

@implementation AcceptCaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _imageView.image=_mockImage;
    
//    [_captionText becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
}
#pragma mark UITextFieldDelegate
- (void)keyboardWillShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //Given size may not account for screen rotation
        int height = MIN(keyboardSize.height,keyboardSize.width);
        //    int width = MAX(keyboardSize.height,keyboardSize.width);
        
        //your other code here..........
        
        
        //    const int movementDistance = 260; // tweak as needed
        const float movementDuration = 0.35f; // tweak as needed
    
    [UIView animateWithDuration:movementDuration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.captionView.frame = CGRectMake(0,_captionView.frame.origin.y-height, _captionView.frame.size.width, _captionView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
        // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //Given size may not account for screen rotation
        int height = MIN(keyboardSize.height,keyboardSize.width);
        //    int width = MAX(keyboardSize.height,keyboardSize.width);
        
        //your other code here..........
        
        
        //    const int movementDistance = 260; // tweak as needed
        const float movementDuration = 0.2f; // tweak as needed
    
    [UIView animateWithDuration:movementDuration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.captionView.frame = CGRectMake(0, _captionView.frame.origin.y+height, _captionView.frame.size.width, _captionView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 80;
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
    
    if ([segue.identifier isEqualToString:@"acceptSendSegue"]){
        
        AcceptSendViewController *destViewController = segue.destinationViewController;
        destViewController.acceptID = appDelegate.accpet_ID;
        destViewController.getMockImage=_mockImage;
        destViewController.isAccept = YES;
        destViewController.captionName = _captionText.text;
    }
}


- (IBAction)doneAction:(id)sender {
     [self performSegueWithIdentifier:@"acceptSendSegue" sender:self];
}

@end
