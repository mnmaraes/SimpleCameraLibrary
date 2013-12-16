//
//  SimpleCameraLibrary.h
//  SimpleCameraLibrary
//
//  Created by Murillo Nicacio de Maraes on 12/16/13.
//  Copyright (c) 2013 MidleOne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTakePictureOptionCropRect @"com.midleone.simplecameralibrary.takepicturekey.croprect"
#define kTakePictureOptionPixelDensity @"com.midleone.simplecameralibrary.takepicturekey.pixeldensity"

typedef void(^SCLTakePictureCompletionBlock)(UIImage *imageTaken);

/**
 * The SCLSimpCamController is intended to be used as a simpler version of UIImagePickerViewController.
 */
@interface SCLSimpCamController : UIViewController

/**----------------------------------------------------------------
 * @name Taking Pictures
 *-----------------------------------------------------------------
 */

/**
 * Takes Picture with the given specifications.
 *
 * @param options The Specification Dictionary for the picture to be taken. Currently accepts two options: CropRect and PixelDensity. Neither option is required.
 *
 * @param completion Block to be executed once the picture has been taken. This is where you do all the necessary actions with the image.
 */
-(void)takePictureWithOptions:(NSDictionary *)options completion:(SCLTakePictureCompletionBlock)completion;

/**
 * Takes Picture
 *
 * @param completion Block to be executed once the picture has been taken. This is where you do all the necessary actions with the image.
 */
-(void)takePicture:(SCLTakePictureCompletionBlock)completion;

@end
