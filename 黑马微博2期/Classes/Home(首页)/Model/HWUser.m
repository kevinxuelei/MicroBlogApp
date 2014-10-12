//
//  HWUser.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWUser.h"

@implementation HWUser

+ (instancetype)userWithDict:(NSDictionary *)dict
{
    HWUser *user = [[self alloc] init];
    user.idstr = dict[@"idstr"];
    user.name = dict[@"name"];
    user.profile_image_url = dict[@"profile_image_url"];
    return user;
}
@end
