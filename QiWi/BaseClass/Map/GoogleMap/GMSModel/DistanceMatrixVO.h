//
//  DistanceMatrixVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/8/4.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLValueObject.h"
#import "DistanceElementVO.h"
@protocol DistanceMatrixVO <NSObject>

@end
@interface DistanceMatrixVO : HLValueObject
@property (nonatomic,copy, nullable) NSArray<DistanceElementVO> *elements;
@end
