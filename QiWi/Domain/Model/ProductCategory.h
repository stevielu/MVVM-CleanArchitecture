//
//  ProductCategory.h
//  QiWi
//
//  Created by stevie on 2019/3/21.
//  Copyright © 2019 IQQL. All rights reserved.
//

#import "HLValueObject.h"

@protocol ProductCategory <NSObject>

@end

@interface ProductCategory : HLValueObject
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *nid;
@property (nonatomic, copy, nullable) NSNumber *code;
@property (nonatomic, copy, nullable) NSNumber *desc;
@property (nonatomic, copy, nullable) NSNumber *category_type;
@property (nonatomic, copy, nullable) NSNumber *parent_category;
@property (nonatomic, copy, nullable) NSArray <ProductCategory *> *sub_cat;
@end


