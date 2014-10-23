//
//  HWEmotionPageView.m
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWEmotionPageView.h"
#import "HWEmotion.h"
#import "HWEmotionPopView.h"
#import "HWEmotionButton.h"

@interface HWEmotionPageView()
/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) HWEmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end

@implementation HWEmotionPageView

- (HWEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [HWEmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        HWEmotionButton *btn = [[HWEmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = emotions[i];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
// 警告原因：尝试去加载的图片不存在

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / HWEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / HWEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%HWEmotionMaxCols) * btnW;
        btn.y = inset + (i/HWEmotionMaxCols) * btnH;
    }
    
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;
}

/**
 *  监听删除按钮点击
 */
- (void)deleteClick
{

}

/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)btnClick:(HWEmotionButton *)btn
{
    // 给popView传递数据
    self.popView.emotion = btn.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height; // 100
    self.popView.centerX = CGRectGetMidX(btnFrame);
    
    // 等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HWSelectEmotionKey] = btn.emotion;
    [HWNotificationCenter postNotificationName:HWEmotionDidSelectNotification object:nil userInfo:userInfo];
}
@end
