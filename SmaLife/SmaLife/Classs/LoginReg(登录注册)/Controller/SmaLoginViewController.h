//
//  SmaLoginViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SectionsViewController.h"
@interface SmaLoginViewController : UIViewController<SecondViewControllerDelegate,UITextFieldDelegate>
{
    UITextField* areaCodeField;
    UILabel *state;
}
@end
