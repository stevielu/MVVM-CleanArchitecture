//
//  PageVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/6/6.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLValueObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface PageVO : HLValueObject
@property (nonatomic, copy, nullable) NSString *next;
@property (nonatomic, copy) NSArray<id> *results;

- (instancetype)addResultsWithNewPage:(PageVO *)page;
@end
NS_ASSUME_NONNULL_END
