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

@interface AcceptParodizeViewController ()
{
    AVCaptureSession *avSession;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureDevice *captureDevice;
    CGRect camViewFrame;
    CGRect camButtonFrame;
    UIImage *stillImage;
    
}
@end

@implementation AcceptParodizeViewController



@synthesize cameraView,messageView,suggestionView,optionsSegment,cameraPoint,messagePoint,suggestionPoint;

@synthesize flashButton,cameraSwitchBtn,cameraButton,fullScreenBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"Parodize!";
    
    optionsSegment.selectedSegmentIndex=0;
    
    messageView.hidden=NO;
    cameraView.hidden=YES;
    suggestionView.hidden=YES;
    
    messagePoint.hidden=NO;
    cameraPoint.hidden=YES;
    suggestionPoint.hidden=YES;
    
    cameraButton.layer.cornerRadius = cameraButton.frame.size.width / 2.0f;
    cameraButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cameraButton.layer.borderWidth = 2.0f;
    cameraButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    //cameraButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //cameraButton.layer.shouldRasterize = YES;
    
    self.timeLabel.text=self.getTimeStr;
    
    self.messageTextiew.text=self.getmessageText;
    
    
    
    if (self.acceptImage.length>0) {
        
        NSData *imageData = [[Context contextSharedManager] dataFromBase64EncodedString:self.acceptImage];
        self.acceptImageView.image= [UIImage imageWithData:imageData];
    }else{
        self.acceptImageView.image=[UIImage imageNamed:@"UserMale.png"];
    }
    
    
     //Camera
    
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
    
    CALayer *layer=[[self view]layer];
    
    layer.masksToBounds=YES;
    
    CGRect cameraFrame=CGRectMake(0, 0, cameraView.frame.size.width, self.view.bounds.size.height);
    
    [previewLayer setFrame:cameraFrame];
    
    [layer insertSublayer:previewLayer atIndex:1];
    
    //[[cameraView layer] addSublayer:previewLayer];
    
    [[cameraView layer] insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    
    NSDictionary *outputSettings=[[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
    [stillImageOutput setOutputSettings:outputSettings];
    
    [avSession addOutput:stillImageOutput];
    
    [avSession startRunning];

   // [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(drawPath:) userInfo:nil repeats:NO];
}
- (void)viewDidLayoutSubviews
{
    
    camViewFrame=cameraView.frame;
    camButtonFrame=cameraButton.frame;

}
-(void)viewWillAppear:(BOOL)animated
{
}

-(void)drawPath:(id)sender
{
    /*CGContextRef context = UIGraphicsGetCurrentContext();
   
    // Pick colors
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    
    // Define triangle dimensions
    CGFloat baseWidth = 30.0;
    CGFloat height = 20.0;
    
    // Define path
    CGContextMoveToPoint(context, detailView.bounds.size.width / 2.0 - baseWidth / 2.0,
                         detailView.bounds.size.height - height);
    CGContextAddLineToPoint(context, detailView.bounds.size.width / 2.0 + baseWidth / 2.0,
                            detailView.bounds.size.height - height);
    CGContextAddLineToPoint(context, detailView.bounds.size.width / 2.0,
                            detailView.bounds.size.height);
    
    // Finalize and draw using path
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    
    CGFloat strokeWidth = 4;
    CGFloat HEIGHTOFPOPUPTRIANGLE = 15;
    CGFloat WIDTHOFPOPUPTRIANGLE = 15;
    CGFloat borderRadius=10;
    
    CGRect currentFrame = detailView.bounds;
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
    
    // Draw and fill the bubble
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, borderRadius + strokeWidth + 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f - WIDTHOFPOPUPTRIANGLE / 2.0f) + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f) + 0.5f, strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, round(currentFrame.size.width / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) - strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, strokeWidth + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Draw a clipping path for the fill
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, borderRadius + strokeWidth + 0.5f, round((currentFrame.size.height + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, round((currentFrame.size.height + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, currentFrame.size.width - strokeWidth - 0.5f, currentFrame.size.height - strokeWidth - 0.5f, round(currentFrame.size.width / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) - strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, currentFrame.size.height - strokeWidth - 0.5f, strokeWidth + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context, strokeWidth + 0.5f, round((currentFrame.size.height + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, currentFrame.size.width - strokeWidth - 0.5f, round((currentFrame.size.height + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, borderRadius - strokeWidth);
    CGContextClosePath(context);
    CGContextClip(context);
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentAction:(UISegmentedControl *)sender
{

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            
            messageView.hidden=NO;
            cameraView.hidden=YES;
            suggestionView.hidden=YES;
            
            messagePoint.hidden=NO;
            cameraPoint.hidden=YES;
            suggestionPoint.hidden=YES;
            break;
        case 1:
            messageView.hidden=YES;
            cameraView.hidden=NO;
            suggestionView.hidden=YES;
            
            messagePoint.hidden=YES;
            cameraPoint.hidden=NO;
            suggestionPoint.hidden=YES;
            break;
        case 2:
            messageView.hidden=YES;
            cameraView.hidden=YES;
            suggestionView.hidden=NO;
            
            messagePoint.hidden=YES;
            cameraPoint.hidden=YES;
            suggestionPoint.hidden=NO;
            break;

            
        default:
            break;
    }
    
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

- (IBAction)takePicture:(id)sender
{
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
            
            // self.navigationController.navigationBar.hidden=NO;
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            stillImage = [UIImage imageWithData:imageData];
            
            [self performSegueWithIdentifier:@"sendSegue" sender:self];
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sendSegue"]) {
        
        AcceptSendViewController *destViewController = segue.destinationViewController;
        destViewController.getImage = stillImage;
        destViewController.acceptID = self.getId;
        destViewController.getMockImage=self.acceptImageView.image;
        destViewController.isAccept = YES;
    }
}
- (IBAction)switchCamera:(id)sender
{
    
    NSArray * inputs =avSession.inputs;
    for ( AVCaptureDeviceInput * INPUT in inputs ) {
        AVCaptureDevice * Device = INPUT.device ;
        if ( [ Device hasMediaType : AVMediaTypeVideo ] ) {
            AVCaptureDevicePosition position = Device . position ; AVCaptureDevice * newCamera = nil ;
            AVCaptureDeviceInput * newInput = nil ;
            
            if ( position == AVCaptureDevicePositionFront )
            {
    
                newCamera = [ self cameraWithPosition : AVCaptureDevicePositionBack ] ;
                flashButton.hidden=NO;
            }
            else
            {
                
                newCamera = [ self cameraWithPosition : AVCaptureDevicePositionFront ] ;
                flashButton.hidden=YES;
                flashButton.selected=NO;
                [self switchOffFlash];
                
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
        
       
        
        cameraButton.hidden=YES;
        cameraSwitchBtn.hidden = YES;
         cameraPoint.hidden=YES;
        
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cameraView.frame=self.view.frame;
            
            
        } completion:^(BOOL finished) {
            
            CGRect rect=cameraButton.frame;
            rect.origin.y=CGRectGetMaxY(cameraView.frame)-85;
            NSLog(@"Get Max %f",CGRectGetMaxY(cameraView.frame));
            cameraPoint.hidden=YES;
            [cameraButton setFrame:rect];
            
            CGRect switchRect=cameraSwitchBtn.frame;
            switchRect.origin.y=cameraButton.center.y;
            [cameraSwitchBtn setFrame:switchRect];
            
            cameraButton.hidden=NO;
            cameraSwitchBtn.hidden = NO;
            
            self.navigationController.navigationBar.hidden=YES;
            
            NSLog(@"After %@ %f",cameraButton,CGRectGetMinY(camButtonFrame));
            
            
            
        }];

    }
    else
    {
        self.navigationController.navigationBar.hidden=NO;
        
         button.selected=NO;
        
        cameraButton.hidden=YES;
        cameraSwitchBtn.hidden = YES;
        
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
            CGRect rect=camViewFrame;
            rect.origin.y=CGRectGetMaxY(self.containerView.frame);
            rect.size.height=CGRectGetMaxY(self.view.frame)-rect.origin.y;
            cameraView.frame=rect;
            
        } completion:^(BOOL finished) {
            
            cameraButton.frame=camButtonFrame;
            
            CGRect switchRect=cameraSwitchBtn.frame;
            switchRect.origin.y=cameraButton.center.y;
            [cameraSwitchBtn setFrame:switchRect];
            
            cameraButton.hidden=NO;
            cameraSwitchBtn.hidden = NO;
            cameraPoint.hidden=NO;
            
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
@end
