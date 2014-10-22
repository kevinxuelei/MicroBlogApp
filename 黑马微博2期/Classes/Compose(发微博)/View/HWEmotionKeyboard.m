//
//  HWEmotionKeyboard.m
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWEmotionKeyboard.h"
#import "HWEmotionListView.h"
#import "HWEmotionTabBar.h"
#import "HWEmotion.h"
#import "MJExtension.h"

@interface HWEmotionKeyboard() <HWEmotionTabBarDelegate>
/** 容纳表情内容的控件 */
@property (nonatomic, weak) UIView *contentView;
/** 表情内容 */
@property (nonatomic, strong) HWEmotionListView *recentListView;
@property (nonatomic, strong) HWEmotionListView *defaultListView;
@property (nonatomic, strong) HWEmotionListView *emojiListView;
@property (nonatomic, strong) HWEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) HWEmotionTabBar *tabBar;
@end

@implementation HWEmotionKeyboard

#pragma mark - 懒加载
- (HWEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[HWEmotionListView alloc] init];
        self.recentListView.backgroundColor = HWRandomColor;
    }
    return _recentListView;
}

- (HWEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[HWEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultListView.emotions = [HWEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.defaultListView.backgroundColor = HWRandomColor;
    }
    return _defaultListView;
}

- (HWEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[HWEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [HWEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.emojiListView.backgroundColor = HWRandomColor;
    }
    return _emojiListView;
}

- (HWEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[HWEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [HWEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.lxhListView.backgroundColor = HWRandomColor;
    }
    return _lxhListView;
}

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.contentView
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        // 2.tabbar
        HWEmotionTabBar *tabBar = [[HWEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.contentView.x = self.contentView.y = 0;
    self.contentView.width = self.width;
    self.contentView.height = self.tabBar.y;
    
    // 3.设置frame
    UIView *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;
}

#pragma mark - HWEmotionTabBarDelegate
- (void)emotionTabBar:(HWEmotionTabBar *)tabBar didSelectButton:(HWEmotionTabBarButtonType)buttonType
{
    // 移除contentView之前显示的控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 根据按钮类型，切换contentView上面的listview
    switch (buttonType) {
        case HWEmotionTabBarButtonTypeRecent: { // 最近
            [self.contentView addSubview:self.recentListView];
            break;
        }
            
        case HWEmotionTabBarButtonTypeDefault: { // 默认
            [self.contentView addSubview:self.defaultListView];
            break;
        }
            
        case HWEmotionTabBarButtonTypeEmoji: { // Emoji
            [self.contentView addSubview:self.emojiListView];
            break;
        }
            
        case HWEmotionTabBarButtonTypeLxh: { // Lxh
            [self.contentView addSubview:self.lxhListView];
            break;
        }
    }
    
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    [self setNeedsLayout];
//    UIView *child = [self.contentView.subviews lastObject];
//    child.frame = self.contentView.bounds;
}

@end
