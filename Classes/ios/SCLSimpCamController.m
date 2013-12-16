//
//  SimpleCameraLibrary.m
//  SimpleCameraLibrary
//
//  Created by Murillo Nicacio de Maraes on 12/16/13.
//  Copyright (c) 2013 MidleOne. All rights reserved.
//

#import "SCLSimpCamController.h"

@interface SCLSimpCamController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController *cameraController;
@property (nonatomic) CGRect cameraFrame;
@property (nonatomic, copy) SCLTakePictureCompletionBlock takePictureCompletionBlock;
@property (nonatomic, copy) NSDictionary *optionDictionary;

@end

@implementation SCLSimpCamController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.cameraController.showsCameraControls = NO;
    self.cameraController.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.cameraFrame = [self frameToFill:self.view];
    [self.cameraController.view setFrame:self.cameraFrame];
    [self.view addSubview:self.cameraController.view];
}

-(CGRect)frameToFill:(UIView *)view
{
    CGSize viewSize = view.frame.size;
    CGFloat ratio = viewSize.height / viewSize.width;
    CGFloat width, height;
    
    if (ratio <= 4./3.) {
        width = viewSize.width;
        height = width * 4./3.;
    } else {
        height = viewSize.height;
        width = height * 3./4.;
    }
    
    CGRect frame = CGRectMake((viewSize.width - width)/2., (viewSize.height - height)/2., width, height);
    
    return frame;
}

#pragma mark - UIImage PrePocessing
-(UIImage *)prepareImage:(UIImage *)image
{
    
    CGSize viewSize = self.view.frame.size;
    
    CGRect cropRect;
    CGFloat scale;
    
    if(self.optionDictionary && [[self.optionDictionary allKeys] containsObject:kTakePictureOptionCropRect])
    {
        cropRect = [[self.optionDictionary objectForKey:kTakePictureOptionCropRect] CGRectValue];
    } else {
        cropRect = self.view.frame;
    }
    
    if (self.optionDictionary && [[self.optionDictionary allKeys] containsObject:kTakePictureOptionPixelDensity]) {
        scale = [[self.optionDictionary objectForKey:kTakePictureOptionPixelDensity] floatValue];
    } else {
        scale = 3.2;
    }
    
    CGFloat targetWidth = cropRect.size.width * scale;
    CGFloat targetHeight = cropRect.size.height * scale;
    CGFloat deltaX = -cropRect.origin.x + (viewSize.width - self.cameraFrame.size.width)/2.;
    CGFloat deltaY = -cropRect.origin.y + (viewSize.height - self.cameraFrame.size.height)/2.;
    deltaX *= scale;
    deltaY *= scale;
    
    CGRect rect = CGRectMake(deltaX, deltaY, self.cameraFrame.size.width * scale, self.cameraFrame.size.height * scale);
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    [image drawInRect:rect];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)takePicture:(SCLTakePictureCompletionBlock)completion
{
    [self takePictureWithOptions:nil completion:completion];
}

-(void)takePictureWithOptions:(NSDictionary *)options completion:(SCLTakePictureCompletionBlock)completion;
{
    self.takePictureCompletionBlock = completion;
    self.optionDictionary = options;
    [self.cameraController takePicture];
}

-(UIImagePickerControllerCameraFlashMode)toggleFlash
{
    UIImagePickerControllerCameraFlashMode current = self.cameraController.cameraFlashMode;
    
    current = current == 1 ? -1 : current + 1;
    
    return self.cameraController.cameraFlashMode = current;
}

-(UIImagePickerControllerCameraFlashMode)currentFlashValue
{
    return self.cameraController.cameraFlashMode;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pictureTaken = [self prepareImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    self.optionDictionary = nil;
    self.takePictureCompletionBlock(pictureTaken);
}

@end

