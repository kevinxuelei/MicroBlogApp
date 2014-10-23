//
//  HWEmotionPopView.m
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWEmotionPopView.h"
#import "HWEmotion.h"
#import "HWEmotionButton.h"

@interface HWEmotionPopView()
@property (weak, nonatomic) IBOutlet HWEmotionButton *emotionButton;
@end

@implementation HWEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)setEmotion:(HWEmotion *)emotion
{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}

@end
