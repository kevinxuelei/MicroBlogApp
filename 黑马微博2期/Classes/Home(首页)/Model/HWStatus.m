//
//  HWStatus.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWStatus.h"
#import "HWUser.h"

@implementation HWStatus

+ (instancetype)statusWithDict:(NSDictionary *)dict
{
    HWStatus *status = [[self alloc] init];
    status.idstr = dict[@"idstr"];
    status.text = dict[@"text"];
    status.user = [HWUser userWithDict:dict[@"user"]];
    return status;
}
@end
