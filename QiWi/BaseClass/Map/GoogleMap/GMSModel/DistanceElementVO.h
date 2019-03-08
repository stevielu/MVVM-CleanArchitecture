//
//  DistanceElementVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/8/4.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLValueObject.h"

@interface DistanceValue : HLValueObject
@property (nonatomic,copy, nullable) NSString *text;
@property (nonatomic,copy, nullable) NSNumber *value;
@end

@protocol DistanceElementVO <NSObject>

@end

@interface DistanceElementVO : HLValueObject
@property (nonatomic,copy, nullable) DistanceValue *distance;
@property (nonatomic,copy, nullable) DistanceValue *duration;
@property (nonatomic,copy, nullable) NSString *status;
@end
