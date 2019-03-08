//
//  GMSDistanceVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/8/4.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLValueObject.h"
#import "DistanceMatrixVO.h"
@interface GMSDistanceVO : HLValueObject
@property (nonatomic,copy, nullable) NSArray<NSString *> *destination_addresses;
@property (nonatomic,copy, nullable) NSArray<NSString *> *origin_addresses;
@property (nonatomic,copy, nullable) NSArray<DistanceMatrixVO> *rows;
@end
