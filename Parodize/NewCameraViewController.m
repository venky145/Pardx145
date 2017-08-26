//
//  NewCameraViewController.m
//  Parodize
//
//  Created by Apple on 14/02/17.
//  Copyright © 2017 Parodize. All rights reserved.
//

#import "NewCameraViewController.h"
#import "ImageEditingViewController.h"
#import "AppDelegate.h"

typedef enum flashRequestType
{
    AutoFlash,
    OnFlash,
    OffFlash
    
} FlashType;


@interface NewCameraViewController (){
    
    CGRect previewFrame;
    UIImage *snapImage;
    
    BOOL isPhotoLibrary;
    BOOL isCameraFront;
    
    FlashType requestType;
}
@end

@implementation NewCameraViewController

@synthesize previewLayer;

AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;
AVCaptureDevice *inputDevice;
AVCaptureDeviceInput *deviceInput;
AVCaptureMovieFileOutput *movieFileOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[Context contextSharedManager] roundImageView:self.photoLibrary withValue:self.photoLibrary.frame.size.height];
    
    self.camSwitch.clipsToBounds = YES;
    self.camSwitch.layer.cornerRadius = self.camSwitch.frame.size.width / 2.0f;
    self.camSwitch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.camSwitch.layer.borderWidth = 2.0f;
    self.camSwitch.layer.shouldRasterize = YES;
    
    self.camSnapButton.clipsToBounds = YES;
    self.camSnapButton.layer.cornerRadius = self.camSnapButton.frame.size.width / 2.0f;
    self.camSnapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.camSnapButton.layer.borderWidth = 2.0f;
    self.camSnapButton.layer.shouldRasterize = YES;
    
    session=nil;
    inputDevice=nil;
    deviceInput=nil;

    // Communicate with the session and other session objects on this queue.
    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhotos:)];
    [imageTap setNumberOfTapsRequired:1];
    [imageTap setNumberOfTouchesRequired:1];
    [_photoLibrary addGestureRecognizer:imageTap];
    
    CGRect camFrame=_cameraView.frame;
    
    camFrame.size.height=_camContainerView.frame.size.height;
    camFrame.size.width=_camContainerView.frame.size.width;
    
    _cameraView.frame=camFrame;

    NSLog(@"%@ %@",_camContainerView,_cameraView);
    
    requestType = AutoFlash;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
        }
    }];
    
    [self loadPhotoToLibrary];
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self loadPhotoToLibrary];
}
-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.topItem.title = @"";
//    self.navigationController.navigationBar.backItem.title = @"";
//    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setHidden:YES];
//    [[Context contextSharedManager] makeClearNavigationBar:self.navigationController];
}
-(void)loadPhotoToLibrary{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];
    [[PHImageManager defaultManager] requestImageForAsset:lastAsset
                                               targetSize:self.photoLibrary.bounds.size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:PHImageRequestOptionsVersionCurrent
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [[self photoLibrary] setImage:result];
                                                });
                                            }];
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@ %@",_camContainerView,_cameraView);
    if (!session) {
     [self setCameraSession];
    }
    
}
-(void)setCameraSession{
    session = [[AVCaptureSession alloc] init];
    
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        
        [session addInput:deviceInput];
        
    }
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [self.cameraView layer];
    //
    [rootLayer setMasksToBounds:YES];
    
    previewFrame = _cameraView.frame;
    
    [previewLayer setFrame:previewFrame];
    
    [rootLayer addSublayer:previewLayer];
    _cameraView.clipsToBounds=YES;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
     [session startRunning];
    
    [self setFlashOptionforCamera:requestType];
}
-(void)openPhotos:(UITapGestureRecognizer *)singleTap
{
    UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.translucent = false;
    imagePicker.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image =  [info objectForKey:UIImagePickerControllerEditedImage];
    isPhotoLibrary=YES;

    [self moveToEditor:image];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)switchAction:(id)sender {
    NSArray * inputs =session.inputs;
    for ( AVCaptureDeviceInput * INPUT in inputs ) {
        AVCaptureDevice * Device = INPUT.device ;
        if ( [ Device hasMediaType : AVMediaTypeVideo ] ) {
            AVCaptureDevicePosition position = Device . position ; AVCaptureDevice * newCamera = nil ;
            AVCaptureDeviceInput * newInput = nil ;
            
            if ( position == AVCaptureDevicePositionFront )
            {
                newCamera = [self cameraWithPosition : AVCaptureDevicePositionBack ] ;
                _flashButton.enabled=YES;
                _flashButton.hidden=NO;
            }
            else
            {
                newCamera = [self cameraWithPosition : AVCaptureDevicePositionFront ] ;
                _flashButton.enabled=NO;
                _flashButton.hidden=YES;
            }
            newInput = [ AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil ] ;
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [session beginConfiguration ] ;
            
            [session removeInput : INPUT ] ;
            [session addInput : newInput ] ;
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [session commitConfiguration ] ;
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

- (IBAction)snapAction:(UIButton *)sender {
    
    [self showActivityInView:self.view withMessage:nil];
    
        dispatch_async( self.sessionQueue, ^{
            AVCaptureConnection *videoConnection = nil;
            for (AVCaptureConnection *connection in stillImageOutput.connections) {
                for (AVCaptureInputPort *port in [connection inputPorts]) {
                    if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                        videoConnection = connection;
                    }
                }
            }
            // Capture a still image.
            [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
                if ( imageDataSampleBuffer ) {
                    // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    NSArray * inputs =session.inputs;
                    for ( AVCaptureDeviceInput * INPUT in inputs ) {
                        AVCaptureDevice * Device = INPUT.device ;
                        if ( [ Device hasMediaType : AVMediaTypeVideo ] ) {
                            AVCaptureDevicePosition position = Device . position ;
                            if ( position == AVCaptureDevicePositionFront )
                            {
                                snapImage=[UIImage imageWithCGImage:[UIImage imageWithData:imageData].CGImage scale:[UIImage imageWithData:imageData].scale orientation:UIImageOrientationLeftMirrored];
                                NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0);
                                NSLog(@"Size of Image(bytes):%f",(float)imgData.length/1024.0f/1024.0f);
                                isCameraFront=YES;
                                
//                                snapImage=[UIImage imageWithData:imageData];
                            }else{
                                NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0);
                                NSLog(@"Size of Image(bytes):%f",(float)imgData.length/1024.0f/1024.0f);
                                snapImage=[UIImage imageWithData:imgData];
                                isCameraFront=NO;
                            }
//                            CGFloat height = self.camContainerView.frame.size.height;
//                            CGFloat width = self.camContainerView.frame.size.width;
                            
//                            snapImage = [[Context contextSharedManager] imageWithImage:snapImage scaledToSize:CGSizeMake(width, height)];

                        }}
                    isPhotoLibrary=NO;
                     //1 it represents the quality of the image.
                    [self hideActivity];
                    
                    [self moveToEditor:snapImage];
                }
                else {
                    NSLog( @"Could not capture still image: %@", error );
                    [self hideActivity];
                }
            }];
        } );
}

-(void)setFlashOptionforCamera:(FlashType)getFlash{

    switch (getFlash) {
        case AutoFlash:
            
            [_flashButton setImage:[UIImage imageNamed:@"auto_flash"] forState:UIControlStateNormal];
            
            [inputDevice lockForConfiguration:nil];
            
            [inputDevice setTorchMode:AVCaptureTorchModeAuto];
            [inputDevice setFlashMode:AVCaptureFlashModeAuto];
            
            [inputDevice unlockForConfiguration];
            break;
        case OnFlash:
            
            [_flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
            [inputDevice lockForConfiguration:nil];
            
//            [inputDevice setTorchMode:AVCaptureTorchModeOn];
            [inputDevice setFlashMode:AVCaptureFlashModeOn];
            
            [inputDevice unlockForConfiguration];
            break;
        case OffFlash:
            
            [_flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            [inputDevice lockForConfiguration:nil];
            
            [inputDevice setTorchMode:AVCaptureTorchModeOff];
            [inputDevice setFlashMode:AVCaptureFlashModeOff];
            
            [inputDevice unlockForConfiguration];
            break;
            
        default:
            break;
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

- (IBAction)flashAction:(id)sender {
    
    switch (requestType) {
        case AutoFlash:
            requestType=OnFlash;
            [self setFlashOptionforCamera:requestType];
            break;
        case OnFlash:
            requestType=OffFlash;
            [self setFlashOptionforCamera:requestType];
            break;
        case OffFlash:
            requestType=AutoFlash;
            [self setFlashOptionforCamera:requestType];
            break;
        default:
            break;
    }
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)moveToEditor:(UIImage *)mockImage{
    
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.getNewImage=mockImage;
    
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ImageEditingViewController *editViewController = [storyBoard instantiateViewControllerWithIdentifier:@"editPhoto"];
//    appDelegate.isImagePicker=isPhotoLibrary;
 //   [self.navigationController pushViewController:editViewController animated:YES];
//    [self presentViewController:editViewController animated:YES completion:nil];
    
    //self.navigationController.navigationBar.hidden=NO;
    [self performSegueWithIdentifier:@"newEdit" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newEdit"]) {
    
        ImageEditingViewController *editViewController = segue.destinationViewController;
        editViewController.isImagePicker=isPhotoLibrary;
        if (_isPlayGround) {
            editViewController.isPlayGround=YES;
            editViewController.isPGResponse=NO;
        }else if(_isPGResponse){
            editViewController.isPlayGround=NO;
            editViewController.isPGResponse=YES;
        }
        editViewController.isAccept=NO;
        if (_isFriend) {
            editViewController.isFriend=YES;
        }
    }
}
/*
-(void)openPhotoLibrary:(UITapGestureRecognizer *)gesture
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.translucent = false;
    imagePicker.navigationBar.barTintColor = [[Context contextSharedManager] colorWithRGBHex:PROFILE_COLOR];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.picker presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"imageDone");
    UIImage *originalImage=info[UIImagePickerControllerOriginalImage];
    
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.getNewImage=originalImage;
    
    //    UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);
    //    UIImageWriteToSavedPhotosAlbum(getImage,
    //                                   self, // send the message to 'self' when calling the callback
    //                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
    //                                   NULL); // you generally won't need a contextInfo here
    
    //    [self dismissViewControllerAnimated:NO completion:^{
    
    if (imagePicker) {
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        imagePicker=nil;
    }
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ImageEditingViewController *tabView = [storyBoard instantiateViewControllerWithIdentifier:@"editPhoto"];
    //tabView.hidesBottomBarWhenPushed = YES;
    
    [self.picker presentViewController:tabView animated:YES completion:nil];
    
    
    // [self performSegueWithIdentifier:@"editPhoto" sender:self];
    
    //   }];
    
    
    
}
*/

@end
