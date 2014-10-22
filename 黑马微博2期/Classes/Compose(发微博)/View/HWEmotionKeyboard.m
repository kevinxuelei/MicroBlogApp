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

@interface HWEmotionKeyboard()
/** 表情内容 */
@property (nonatomic, weak) HWEmotionListView *listView;
/** tabbar */
@property (nonatomic, weak) HWEmotionTabBar *tabBar;
@end

@implementation HWEmotionKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.表情内容
        HWEmotionListView *listView = [[HWEmotionListView alloc] init];
        listView.backgroundColor = HWRandomColor;
        [self addSubview:listView];
        self.listView = listView;
        
        // 2.tabbar
        HWEmotionTabBar *tabBar = [[HWEmotionTabBar alloc] init];
        tabBar.backgroundColor = HWRandomColor;
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
    self.tabBar.height = 44;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.listView.x = self.listView.y = 0;
    self.listView.width = self.width;
    self.listView.height = self.tabBar.y;
}

@end
