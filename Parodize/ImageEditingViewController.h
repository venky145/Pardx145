//
//  ImageEditingViewController.h
//  Parodize
//
//  Created by administrator on 18/10/15.
//  Copyright (c) 2015 Parodize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"
#import "GPUImage.h"
#import "DrawLine.h"

// OpenGL
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

typedef enum {
    RGB_FILTER,
    WHITE_BALANCE_FILTER,
    MONOCHROME_FILTER,
    AMATORKA_FILTER,
    ETIKA_FILTER,
    ELEGANCE_FILTER,
    INVERT_FILTER,
    THRESHOLD_FILTER,
    SOBEL_FILTER,
    TOON_FILTER,
    TILT_FILTER,
    POSTERIZE_FILTER,
    EMBOSS_FILTER,
    KUWAHARA_FILTER,
    CUSTOM_FILTER,
    UI_ELEMENT_FILTER,
    GRAYSCALE_FILTER,
    SEPIA_FILTER,
    SKETCH_FILTER,
    GAUSSIAN_FILTER,
    POLKA_FILTER
} ShowcaseFilterType;

@interface ImageEditingViewController : ActivityBaseViewController <UITextFieldDelegate,PECropViewControllerDelegate,UIScrollViewDelegate>
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

@property(assign) BOOL isAccept;
@property(assign) BOOL isImagePicker;
@property(assign) BOOL isPlayGround;
@property (assign) BOOL isPGResponse;
@property (assign) BOOL isFriend;;

@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;

@property (strong, nonatomic) IBOutlet UIView *colorContainer;
@property (weak, nonatomic) IBOutlet DrawLine *drawLineView;
@property (weak, nonatomic) IBOutlet UIView *penColorView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *colorButton;

@property (nonatomic,retain) UIImage *getImage;

//Sliders

@property (strong, nonatomic) IBOutlet UISlider *brightSlider;

//filter buttons

@property (weak, nonatomic) IBOutlet UIButton *brightButton;
@property (weak, nonatomic) IBOutlet UIButton *contrastButton;
@property (weak, nonatomic) IBOutlet UIButton *hueButton;
@property (weak, nonatomic) IBOutlet UIButton *saturationButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

- (IBAction)cacelAction:(id)sender;

- (IBAction)doneAction:(id)sender;

- (IBAction)filterAction:(UIBarButtonItem *)button;

- (IBAction)colorAction:(UIBarButtonItem *)button;

- (IBAction)brightnessValue:(UISlider *)sender;

- (IBAction)brightnessAction:(id)sender;

- (IBAction)contrastAction:(id)sender;

- (IBAction)hueAction:(id)sender;

- (IBAction)saturationAction:(id)sender;

- (IBAction)deleteAction:(id)sender;
- (IBAction)penToolAction:(id)sender;
- (IBAction)undoAction:(id)sender;


//Test label
@property (weak, nonatomic) IBOutlet UILabel *sliderTestLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *penButton;

@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;


@end
