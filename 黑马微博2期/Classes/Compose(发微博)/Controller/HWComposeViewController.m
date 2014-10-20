//
//  HWComposeViewController.m
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWComposeViewController.h"
#import "HWAccountTool.h"
#import "HWTextView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

@interface HWComposeViewController ()
/** 输入控件 */
@property (nonatomic, weak) HWTextView *textView;
@end

@implementation HWComposeViewController
#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 添加输入控件
    [self setupTextView];
    
    // 默认是YES：当scrollView遇到UINavigationBar、UITabBar等控件时，默认会设置scrollView的contentInset
//    self.automaticallyAdjustsScrollViewInsets;
}

- (void)dealloc
{
    [HWNotificationCenter removeObserver:self];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    HWLog(@"%@", NSStringFromUIEdgeInsets(self.textView.contentInset));
//}

#pragma mark - 初始化方法
/**
 * 设置导航栏内容
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *name = [HWAccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = prefix;
    }
    
    //    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    //    att.image = [UIImage imageNamed:@"vip"];
    //    NSAttributedString *str2 = [NSAttributedString attributedStringWithAttachment:att];
    //    [attrStr appendAttributedStr];ing:str2
    //
    //
    //    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"哈哈"]];
    
    
    
    //    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:name]];
    //    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor blueColor] range:[str rangeOfString:name]];
    //    NSShadow *shadow = [[NSShadow alloc] init];
    ////    shadow.shadowColor = [UIColor blueColor];
    //    shadow.shadowBlurRadius = 10;
    //    shadow.shadowOffset = CGSizeMake(1, 1);
    //    [attrStr addAttribute:NSStrokeWidthAttributeName value:@1 range:[str rangeOfString:name]];
    //    self.navigationItem.title = [NSString stringWithFormat:@"发微博\r\n%@", [HWAccountTool account].name];
}

/**
 * 添加输入控件
 */
- (void)setupTextView
{
    // 在这个控制器中，textView的contentInset.top默认会等于64
    HWTextView *textView = [[HWTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
//    textView.placeholderColor = [UIColor redColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 监听通知
    [HWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}

/**
 UITextField:
     1.文字永远是一行，不能显示多行文字
     2.有placehoder属性设置占位文字
     3.继承自UIControl
     4.监听行为
     1> 设置代理
     2> addTarget:action:forControlEvents:
     3> 通知:UITextFieldTextDidChangeNotification
 
 UITextView:
     1.能显示任意行文字
     2.不能设置占位文字
     3.继承自UIScollView
     4.监听行为
     1> 设置代理
     2> 通知:UITextViewTextDidChangeNotification
 */


#pragma mark - 监听方法
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send {
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	pic false binary 微博的配图。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [HWAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
    // 4.dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
@end
