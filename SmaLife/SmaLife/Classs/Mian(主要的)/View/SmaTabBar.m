//
//  SmaTabBar.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaTabBar.h"
#import "SmaTabBarButton.h"



@interface SmaTabBar()

@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, weak) SmaTabBarButton *selectedButton;


@end

@implementation SmaTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
        
        // 添加一个加号按钮
   
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_action_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_action_button_highlighted"] forState:UIControlStateHighlighted];
        
//        [plusButton setImage:[UIImage imageWithName:@"tabbar_action_button"] forState:UIControlStateNormal];
//        [plusButton setImage:[UIImage imageWithName:@"tabbar_action_button_highlighted"] forState:UIControlStateHighlighted];
        //plusButton.currentBackgroundImage.size.width,plusButton.currentBackgroundImage.size.height
        plusButton.bounds = CGRectMake(0, 0,(320/5-20),44);
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return self;
}

- (void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    SmaTabBarButton *button = [[SmaTabBarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    button.titleLabel.text=item.title;
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(SmaTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
 
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    // 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        // 1.取出按钮
        SmaTabBarButton *button = self.tabBarButtons[index];
        
        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        if (index > 1) {
            buttonX += buttonW;
        }

        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 3.绑定tag
        button.tag = index;
    }
}




#pragma mark - DCPathButton Delegate


@end
