//
//  IWSearchBar.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "SmaTextField.h"

@interface SmaTextField()
@end

@implementation SmaTextField
+ (instancetype)smaTextField
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景
        //self.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
        //self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //UIControlContentVerticalAlignmentBottom
        self.textColor=[UIColor whiteColor];
        self.tintColor=[UIColor whiteColor];
        // 字体
        self.font = [UIFont systemFontOfSize:18];
        // 右边的清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.returnKeyType =UIReturnKeyDone;
        // 设置键盘右下角按钮的样式
        //self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置左边图标的frame
    self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);
}

@end
