//
//  SmaSportPlanController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSportPlanController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *slideView;
@property (weak, nonatomic) IBOutlet UILabel *remarklab;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *distancelab;
@property (weak, nonatomic) IBOutlet UILabel *steplab;

@property (weak, nonatomic) IBOutlet UILabel *calorielab;
@property (weak, nonatomic) IBOutlet UIImageView *footView;
@end
