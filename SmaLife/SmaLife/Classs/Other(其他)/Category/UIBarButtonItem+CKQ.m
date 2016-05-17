//
//  UIBarButtonItem+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIBarButtonItem+CKQ.h"

@implementation UIBarButtonItem (CKQ)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:icon];
   // CGSize size={img.size.width,img.size.height};
    UIImage *img1=[UIImage imageNamed:highIcon];
    //CGSize size1={img1.size.width,img1.size.height};
    
    [button setBackgroundImage:img forState:UIControlStateNormal];
    
    //[button setBackgroundImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    [button setBackgroundImage:img1 forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
