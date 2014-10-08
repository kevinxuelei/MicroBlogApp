//
//  HWTabBarViewController.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWTabBarViewController.h"
#import "HWHomeViewController.h"
#import "HWMessageCenterViewController.h"
#import "HWDiscoverViewController.h"
#import "HWProfileViewController.h"
#import "HWNavigationController.h"
#import "HWTabBar.h"

@interface HWTabBarViewController () <HWTabBarDelegate>

@end

@implementation HWTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化子控制器
    HWHomeViewController *home = [[HWHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    HWMessageCenterViewController *messageCenter = [[HWMessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    HWDiscoverViewController *discover = [[HWDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    HWProfileViewController *profile = [[HWProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2.更换系统自带的tabbar
    //    self.tabBar = [[HWTabBar alloc] init];
    HWTabBar *tabBar = [[HWTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //    self.tabBar = tabBar;
    
//    Person *p = [[Person allooc] init];
//    p.name = @"jack";
//    [p setValue:@"jack" forKeyPath:@"name"];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    int count = self.tabBar.subviews.count;
//    for (int i = 0; i<count; i++) {
//        UIView *child = self.tabBar.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            child.width = self.tabBar.width / count;
//        }
//    }
//}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
//    childVc.tabBarItem.title = title; // 设置tabbar的文字
//    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = HWRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HWNavigationController *nav = [[HWNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - HWTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(HWTabBar *)tabBar
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
