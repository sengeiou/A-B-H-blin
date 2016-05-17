//
//  MJHeaderView.m
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "SmaHeaderView.h"
#import "SmaSettingGroup.h"

/**
 某个控件出不来:
 1.frame的尺寸和位置对不对
 
 2.hidden是否为YES
 
 3.有没有添加到父控件中
 
 4.alpha 是否 < 0.01
 
 5.被其他控件挡住了
 
 6.父控件的前面5个情况
 */

@interface SmaHeaderView()
@property (nonatomic, weak) UIButton *nameView;
@end

@implementation SmaHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    SmaHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[SmaHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 1.添加按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        // 背景图片
        [nameView setBackgroundImage:[UIImage imageNamed:@"table_head_backgound"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置按钮的内容左对齐
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter; //
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        
    }
    return self;
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    self.nameView.frame = self.bounds;
}

- (void)setGroup:(SmaSettingGroup *)group
{
    _group = group;
    // 1.设置按钮文字(组名)
    [self.nameView setTitle:group.name forState:UIControlStateNormal];
}

@end
