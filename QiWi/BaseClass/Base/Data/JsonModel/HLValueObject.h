//
//  HLValueObject.h
//  HLSmartWay
//
//  Created by stevie on 2018/4/28.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface HLValueObject : JSONModel

/**
 *  通过字典创建VO
 *
 *  @param aDict 字典
 *
 *  @return VO
 */
+ (_Nullable instancetype)voWithDict:(NSDictionary<NSString *, id> * _Nullable)aDict;
+ (_Nullable instancetype)voWithJson:(NSString * _Nullable)aJson;

@end

