//
//  AcceptParodizeViewController.m
//  Parodize
//
//  Created by administrator on 01/11/15.
//  Copyright © 2015 Parodize. All rights reserved.
//

#import "AcceptParodizeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AcceptSendViewController.h"
#import "ImageEditingViewController.h"
#import "AppDelegate.h"
#import "AcceptCompareController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ProfileImageController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface AcceptParodizeViewController ()
{
    UIImagePickerController *imagePicker;
    AVCaptureSession *avSession;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureDevice *captureDevice;
    CGRect camViewFrame;
    CGRect camButtonFrame;
    UIImage *stillImage;
    AppDelegate *appDelegate;
    BOOL isFullScreen;
    UIImage *mockImage;
    
}
//@property (strong, nonatomic) UIImageView *libraryImage;
@end

@implementation AcceptParodizeViewController



@synthesize cameraView,isNotification;

@synthesize flashButton,cameraSwitchBtn,cameraButton,fullScreenBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.acceptModel=appDelegate.acceptModel;
    
    self.title=@"Parodize!";
    
    cameraButton.layer.cornerRadius = cameraButton.frame.size.width / 2.0f;
    cameraButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cameraButton.layer.borderWidth = 2.0f;
   
    
    self.timeLabel.text=[[Context contextSharedManager] setDateInterval:self.acceptModel.time];
    if (self.acceptModel.caption.length>0) {
        
        self.tagsLabel.text=self.acceptModel.caption;
    }else
    {
        self.tagsLabel.text=@"No Caption ...";
    }

    if (isNotification) {
        
        [self requestAcceptParticular];
    }else{
        
        [self.acceptImageView sd_setImageWithURL:[NSURL URLWithString:self.acceptModel.image] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.loadIndicator stopAnimating];
            mockImage=image;
        }];
    }
    
    
    [_doneButton setBackgroundColor:[[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR] colorWithAlphaComponent:0.8]];
    
    [_retakeButton setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.8]];
    
    [self makeCornersRound:_retakeButton withColor:[[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR]];
    [self makeCornersRound:_doneButton withColor:[UIColor whiteColor]];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photosLibrary:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [self.cameraRoll addGestureRecognizer:singleTap];
    
    self.cameraRoll.clipsToBounds = YES;
    //  self.cameraRoll.layer.cornerRadius = self.cameraRoll.frame.size.width / 2.0f;
    self.cameraRoll.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cameraRoll.layer.borderWidth = 2.0f;
    self.cameraRoll.userInteractionEnabled = YES; //disabled by default
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    if (!avSession) {
        [self openCamera];
    }
    
}
-(void)openCamera{
    //Camera
    
    [self setcameraButtonsStatus:YES];
    
    avSession=[[AVCaptureSession alloc]init];
    [avSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    captureDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput=[AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if ([avSession canAddInput:deviceInput])
    {
        [avSession  addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:avSession];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *layer=[self.cameraView layer];
    
    layer.masksToBounds=YES;
    
    CGRect cameraFrame=CGRectMake(0, 0, self.cameraView.frame.size.width, self.cameraView.frame.size.height);
    
    [previewLayer setFrame:cameraFrame];
    
    [layer insertSublayer:previewLayer atIndex:1];
    
    //[[cameraView layer] addSublayer:previewLayer];
    
//    [[cameraView layer] insertSublayer:previewLayer atIndex:0];
    
    if (captureDevice.position==AVCaptureDevicePositionFront) {
        
        flashButton.hidden=YES;
    }else{
        flashButton.hidden=NO;
    }
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    
    NSDictionary *outputSettings=[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
    [stillImageOutput setOutputSettings:outputSettings];
    
    [avSession addOutput:stillImageOutput];
    
    [avSession startRunning];
    
    
    [_tagsLabel setBackgroundColor:[[[Context contextSharedManager]colorWithRGBHex:PROFILE_COLOR ] colorWithAlphaComponent:0.6]];
    
    _pictureView.hidden=YES;

    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];
    [[PHImageManager defaultManager] requestImageForAsset:lastAsset
                                               targetSize:self.cameraRoll.bounds.size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:PHImageRequestOptionsVersionCurrent
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [[self cameraRoll] setImage:result];
                                                    
                                                });
                                            }];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLayoutSubviews
{
    
    camViewFrame=cameraView.frame;
    camButtonFrame=cameraButton.frame;
    NSLog(@"frame....%f",camButtonFrame.origin.y);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestAcceptParticular{
    
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.acceptModel.id],@"id", nil];
    
    [[DataManager sharedDataManager] requestAcceptParticular:dict forSender:self];
}
#pragma DataManagerDelegate  Methods

-(void) didGetAcceptedParticular:(NSMutableDictionary *) dataDictionary {
    
    //NSLog(@"Yahooooo... \n %@",dataDictionary);
    
    
    
    if ([dataDictionary objectForKey:RESPONSE_ERROR]) {
        
        [self.loadIndicator stopAnimating];
        
        [[Context contextSharedManager] showAlertView:self withMessage:[dataDictionary objectForKey:RESPONSE_ERROR] withAlertTitle:SERVER_ERROR];
        
    }
    else
    {
        
        NSDictionary *successDict=[dataDictionary objectForKey:@"success"];
        
//        imageData = [[Context contextSharedManager] dataFromBase64EncodedString:[successDict objectForKey:@"image"]];
        
//        self.acceptImageView.image = [UIImage imageWithData:imageData];
        
//        [self.acceptImageView sd_setImageWithURL:[successDict objectForKey:@"image"]];
        
        [self.acceptImageView sd_setImageWithURL:[successDict objectForKey:@"image"] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.loadIndicator stopAnimating];
            mockImage=image;
        }];
        
    }
}
-(void) requestDidFailWithRequest:(NSError *) error {
    
    NSLog(@"Error");
    
     [self.loadIndicator stopAnimating];
    
    [[Context contextSharedManager] showAlertView:self withMessage:SERVER_REQ_ERROR withAlertTitle:SERVER_ERROR];
}
#pragma mark Class Methods
-(void)makeCornersRound:(UIButton *)sender withColor:(UIColor *)color{
    
    sender.clipsToBounds = YES;
    sender.layer.cornerRadius = 2.0f;
    sender.layer.borderColor = color.CGColor;
    sender.layer.borderWidth = 2.0f;
}

-(void)photosLibrary:(UITapGestureRecognizer *)gesture
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.translucent = false;
    imagePicker.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"imageDone");
     self.navigationController.navigationBar.hidden=NO;
    stillImage=info[UIImagePickerControllerEditedImage];
    _pictureView.hidden=NO;
    cameraView.hidden=YES;
    
    _snapImageView.image=stillImage;
    
//    [_snapImageView setImage:[[Context contextSharedManager] imageWithImage:stillImage scaledToSize:_pictureView.frame.size]];
    
//    if (isFullScreen) {
//        
//        [self cameraFullScreen:nil];
//    }
    if (imagePicker) {
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        imagePicker=nil;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"messageCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
    
    
    return nil;
}
-(void)setcameraButtonsStatus:(BOOL)status{
    cameraButton.enabled=status;
    cameraSwitchBtn.enabled=status;
    fullScreenBtn.enabled=status;
    _cameraRoll.userInteractionEnabled=status;
}
- (IBAction)takePicture:(id)sender
{
    
    [self setcameraButtonsStatus:NO];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            
             self.navigationController.navigationBar.hidden=NO;
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            
            NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0);
            stillImage = [UIImage imageWithData:imgData];
            _pictureView.hidden=NO;
            cameraView.hidden=YES;
            
            [_snapImageView setImage:stillImage];
        
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"acceptEdit"]) {
    
        [self hideActivity];
        ImageEditingViewController *tabView = segue.destinationViewController;
        tabView.isAccept=YES;
    
    }

}
- (IBAction)switchCamera:(id)sender{
    NSArray * inputs =avSession.inputs;
    for ( AVCaptureDeviceInput * INPUT in inputs ) {
        AVCaptureDevice * Device = INPUT.device ;
        if ( [ Device hasMediaType : AVMediaTypeVideo ] ) {
            AVCaptureDevicePosition position = Device . position ; AVCaptureDevice * newCamera = nil ;
            AVCaptureDeviceInput * newInput = nil ;
            if ( position == AVCaptureDevicePositionFront )
            {
                if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear ])
                {
                    newCamera = [ self cameraWithPosition : AVCaptureDevicePositionBack ] ;
                    flashButton.hidden=NO;
                }
                
            }
            else
            {
                if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront])
                {
                    newCamera = [ self cameraWithPosition : AVCaptureDevicePositionFront ] ;
                    flashButton.hidden=YES;
                    flashButton.selected=NO;
                    [self switchOffFlash];
                }
               
            }
            newInput = [ AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil ] ;
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [avSession beginConfiguration ] ;
            
            [avSession removeInput : INPUT ] ;
            [avSession addInput : newInput ] ;
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [avSession commitConfiguration ] ;
            break ;
        }
    }

    
}
- ( AVCaptureDevice * ) cameraWithPosition : ( AVCaptureDevicePosition ) position
{
    NSArray * Devices = [ AVCaptureDevice devicesWithMediaType : AVMediaTypeVideo ] ;
    for ( AVCaptureDevice * Device in Devices )
        if ( Device . position == position )
            return Device ;
    return nil ;
}
- (IBAction)cameraFullScreen:(UIButton *)button {
    
    if (!button.selected)
    {
        
        button.selected=YES;
        isFullScreen=YES;
        cameraButton.hidden=YES;
        cameraSwitchBtn.hidden = YES;
        _cameraRoll.hidden=YES;
        
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cameraView.frame=self.view.frame;
   
        } completion:^(BOOL finished) {
            
            CGRect rect=cameraButton.frame;
            rect.origin.y=CGRectGetMaxY(cameraView.frame)-85;
            NSLog(@"Get Max %f",CGRectGetMaxY(cameraView.frame));
            [cameraButton setFrame:rect];
            
            CGRect switchRect=cameraSwitchBtn.frame;
            switchRect.origin.y=cameraButton.center.y;
            [cameraSwitchBtn setFrame:switchRect];
            
            CGRect rollRect=_cameraRoll.frame;
            rollRect.origin.y=cameraButton.frame.origin.y;
            [_cameraRoll setFrame:rollRect];
            
            cameraButton.hidden=NO;
            cameraSwitchBtn.hidden = NO;
            _cameraRoll.hidden=NO;
            
            self.navigationController.navigationBar.hidden=YES;
            
            NSLog(@"After %@ %f",cameraButton,CGRectGetMinY(camButtonFrame));
            
            
            
        }];

    }
    else
    {
        self.navigationController.navigationBar.hidden=NO;
        
         button.selected=NO;
        isFullScreen=NO;
        
        cameraButton.hidden=YES;
        cameraSwitchBtn.hidden = YES;
        _cameraRoll.hidden=YES;
        
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
            CGRect rect=camViewFrame;
            rect.origin.y=CGRectGetMaxY(self.containerView.frame);
            rect.size.height=CGRectGetMaxY(self.view.frame)-rect.origin.y;
            cameraView.frame=rect;
            
        } completion:^(BOOL finished) {
            
           // cameraButton.frame=camButtonFrame;
            
            //CGRect switchRect=cameraSwitchBtn.frame;
           // switchRect.origin.y=cameraButton.center.y;
            //[cameraSwitchBtn setFrame:switchRect];
            
            cameraButton.hidden=NO;
            cameraSwitchBtn.hidden = NO;
            _cameraRoll.hidden=NO;
        }];

    }
}

- (IBAction)flashCamera:(UIButton *)button
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        // AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([captureDevice hasTorch] && [captureDevice hasFlash])
        {
            
            if (!button.selected)
            {
                button.selected=YES;
                [self switchOnFlash];
            }
            else
            {
                button.selected=NO;
                [self switchOffFlash];
                
            }
            
        }
    }
}
-(void)switchOnFlash
{
    [captureDevice lockForConfiguration:nil];
    
    [captureDevice setTorchMode:AVCaptureTorchModeOn];
    [captureDevice setFlashMode:AVCaptureFlashModeOn];
    
    [captureDevice unlockForConfiguration];
}
-(void)switchOffFlash
{
    [captureDevice lockForConfiguration:nil];
    
    [captureDevice setTorchMode:AVCaptureTorchModeOff];
    [captureDevice setFlashMode:AVCaptureFlashModeOff];
    
    [captureDevice unlockForConfiguration];

}
- (IBAction)retakeAction:(id)sender {
    
    if (isFullScreen) {
        
        [self cameraFullScreen:nil];
    }
    
    _pictureView.hidden=YES;
    cameraView.hidden=NO;
    [self setcameraButtonsStatus:YES];
    
}

- (IBAction)doneAction:(id)sender {
    
    [self showActivityWithMessage:nil];
    appDelegate.getNewImage=stillImage;
    
    self.navigationController.navigationBar.hidden=NO;
    [self performSegueWithIdentifier:@"acceptEdit" sender:self];

}
- (IBAction)cameraGesture:(id)sender {
    
    NSLog(@"camera gesture");
    if (stillImage) {
        [self presentFullImageView:stillImage];
    }
    
}

- (IBAction)mockGesture:(id)sender {
    NSLog(@"mock gesture");
    if (mockImage) {
        [self presentFullImageView:mockImage];
    }
}

-(void)presentFullImageView:(UIImage *)fullImage{
    
    ProfileImageController *profileView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileImage"];
    
    profileView.profileData=fullImage;
    
//    profileView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    
    [self presentViewController:profileView animated:NO completion:nil];
    
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
