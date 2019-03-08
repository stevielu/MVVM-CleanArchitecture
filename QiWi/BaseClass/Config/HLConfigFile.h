//
//  HLConfigFile.h
//  HLSmartWay
//
//  Created by stevie on 2018/8/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLConfigFile : NSObject

+ (HLConfigFile * __nonnull)sharedInstance;

- (void)getConfig;
@end
