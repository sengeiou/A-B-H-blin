//
//  SCCaptureCameraController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCaptureSessionManager.h"
#import "SamCoreBlueTool.h"

@interface SCCaptureCameraController : UIViewController<SetSamCoreBlueToolDelegate>

@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;


@end
