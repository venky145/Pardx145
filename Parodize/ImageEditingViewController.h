//
//  ImageEditingViewController.h
//  Parodize
//
//  Created by administrator on 18/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

// OpenGL
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface ImageEditingViewController : ActivityBaseViewController <UITextFieldDelegate,PECropViewControllerDelegate>
{
    // The pixel dimensions of the backbuffer
    GLint backingWidth;
    GLint backingHeight;
    // OpenGL names for the renderbuffer and framebuffer used to render to this view
    GLuint viewRenderbuffer, viewFramebuffer;
    
    float textViewHeight;
    
    float chatOrigin;
}

@property(strong,nonatomic) UIImage *snapImage;

- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;


@property (weak, nonatomic) IBOutlet UIView *captionView;

@property (nonatomic,retain) UIImage *getImage;

- (IBAction)cacelAction:(id)sender;

- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cropButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *colorButton;

- (IBAction)cropAction:(UIBarButtonItem *)button;

- (IBAction)filterAction:(UIBarButtonItem *)button;

- (IBAction)colorAction:(UIBarButtonItem *)button;

@property (strong, nonatomic) IBOutlet UIView *colorContainer;

@property (strong, nonatomic) IBOutlet UIScrollView *filterScrollView;

- (IBAction)editAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

//Sliders

@property (strong, nonatomic) IBOutlet UISlider *brightSlider;
- (IBAction)brightnessValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *contrastSlider;
- (IBAction)contrastValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;

- (IBAction)staurationValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *hueSlider;

- (IBAction)hueValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *sharpSlider;

- (IBAction)sharpValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UILabel *brightLabel;

@property (strong, nonatomic) IBOutlet UILabel *contrastLabel;
//
@property (strong, nonatomic) IBOutlet UILabel *hueLabel;

@property (strong, nonatomic) IBOutlet UILabel *saturationLabel;

- (IBAction)brightnessAction:(id)sender;

- (IBAction)contrastAction:(id)sender;

- (IBAction)hueAction:(id)sender;

- (IBAction)saturationAction:(id)sender;

@end
