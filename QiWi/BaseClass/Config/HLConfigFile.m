//
//  HLConfigFile.m
//  HLSmartWay
//
//  Created by stevie on 2018/8/17.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLConfigFile.h"
@interface HLConfigFile ()
@property (nonatomic, strong) ConfigLogic *logic;
@end
@implementation HLConfigFile
DEF_SINGLETON(HLConfigFile);


- (ConfigLogic *)logic
{
    if ( ! _logic) {
        _logic = [[ConfigLogic alloc] initWithOperationManagerObj:self.operationManager];
    }
    
    return _logic;
}

- (void)getConfig
{
    [self.logic getWithHandle:nil];
}
@end
