//
//  GPUImageGrayscaleFilterOne.m
//  GPUImage
//
//  Created by Apple on 27/01/17.
//  Copyright © 2017 Brad Larson. All rights reserved.
//

#import "GPUImageGrayscaleFilterOne.h"

@implementation GPUImageGrayscaleFilterOne
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageLuminanceFragmentShaderString2 = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 const highp vec3 W = vec3(0.3125, 0.5154, 0.0721);
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, W);
     
     gl_FragColor = vec4(vec3(luminance), textureColor.a);
 }
 );
#else
NSString *const kGPUImageLuminanceFragmentShaderString2 = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 const vec3 W = vec3(0.3125, 0.5154, 0.0721);
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, W);
     
     gl_FragColor = vec4(vec3(luminance), textureColor.a);
 }
 );
#endif


- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (!currentlyReceivingMonochromeInput)
    {
        [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    }
}
- (BOOL)wantsMonochromeInput;
{
    //    return YES;
    return NO;
}

- (BOOL)providesMonochromeOutput;
{
    //    return YES;
    return NO;
}


#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLuminanceFragmentShaderString2]))
    {
        return nil;
    }
    
    return self;
}


@end

