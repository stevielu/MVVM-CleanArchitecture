//
//  DeadTimer.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/11.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "DeadTimer.h"

@interface DeadTimer ()

@property (nonatomic, copy) DeadTimerBlock block;

@property (nonatomic, strong) NSTimer *countdownTimer;

@property (nonatomic, copy) NSDate *deadTime;

@end

@implementation DeadTimer

- (void)runCountdownView
{
    NSDate *now = [NSDate date];
    if ([self.deadTime compare:now] == NSOrderedDescending) {
        NSTimeInterval timeInterval = [self.deadTime timeIntervalSinceDate:now];
        NSDate *endingDate = now;
        NSDate *startingDate = [endingDate dateByAddingTimeInterval:-timeInterval];
        
        NSCalendarUnit components = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:startingDate toDate:endingDate options:(NSCalendarOptions)0];
        
        if (self.block) {
            self.block(dateComponents);
        }
    }
    else {
        if (self.block) {
            self.block(nil);
        }
        
        [self stop];
    }
}

- (void)runWithDeadtime:(NSDate *)deadtime andBlock:(DeadTimerBlock)aBlock
{
    self.block = aBlock;
    
    self.deadTime = deadtime;
    
    [self stop];
    
    WEAK_SELF;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakSelf selector:@selector(runCountdownView) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];
}

- (void)stop
{
    [self.countdownTimer invalidate];
}

@end
