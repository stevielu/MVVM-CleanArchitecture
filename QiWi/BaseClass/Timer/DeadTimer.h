//
//  DeadTimer.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/11.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  为nil则表示已经倒计时完成了
 *
 *  @param dateComponents
 */
typedef void(^DeadTimerBlock)(NSDateComponents *dateComponents);

@interface DeadTimer : NSObject

- (void)runWithDeadtime:(NSDate *)deadtime andBlock:(DeadTimerBlock)aBlock;
- (void)stop;

@end

