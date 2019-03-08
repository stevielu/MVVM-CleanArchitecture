//
//  PageVO.m
//  HLSmartWay
//
//  Created by stevie on 2018/6/6.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "PageVO.h"

@implementation PageVO
- (instancetype)addResultsWithNewPage:(PageVO *)page
{
    self.next = page.next;
    self.results = [self.results arrayByAddingObjectsFromArray:page.results];
    
    return self;
}

@end
