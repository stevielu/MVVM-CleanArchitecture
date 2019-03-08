//
//  HLRefreshHeader.m
//  HLSmartWay
//
//  Created by stevie on 2018/6/6.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLRefreshHeader.h"

@implementation HLRefreshHeader
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.automaticallyChangeAlpha = true;
}
@end
