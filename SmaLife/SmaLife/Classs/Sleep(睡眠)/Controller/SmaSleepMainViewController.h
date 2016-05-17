//
//  SmaSleepMianViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSleepMainViewController : UIViewController
{
    NSString *path;
    NSMutableArray *array;
}
@property (nonatomic,strong) NSDate *data;
@property (nonatomic,assign) BOOL isWear;
@end
