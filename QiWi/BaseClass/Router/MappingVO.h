//
//  MappingVO.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/9.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MappingClassCreateType)
{
    MappingClassCreateByStoryboard = 0,//storyboard方式创建
    MappingClassCreateByXib        = 1,//xib方式创建
    MappingClassCreateByCode       = 2,//编码方式创建
};

typedef NS_ENUM(NSUInteger, MappingClassPlatformType)
{
    MappingClassPlatformTypeUniversal = 0,//任何平台都load
    MappingClassPlatformTypePhone     = 1,//只在iPhone上load
    MappingClassPlatformTypePad       = 2,//只在iPad上load
};

@interface MappingVO : NSObject
/**
 * 绑定视图处理模块reactor
 */
@property (nonatomic, strong) NSObject *intereactor;
/**
 *  创建的类名
 */
@property (nonatomic, strong) NSString *className;
/**
 *  创建的方式
 */
@property (nonatomic) MappingClassCreateType createdType;
/**
 *  load过滤
 */
@property (nonatomic) MappingClassPlatformType loadFilterType;
/**
 *  资源文件存放的bundle名称
 */
@property (nonatomic, strong) NSString *bundleName;
/**
 *  资源文件名称
 */
@property (nonatomic, strong) NSString *nibName;
/**
 *  storyboard名称
 */
@property (nonatomic, strong) NSString *storyboardName;
/**
 *  storyboard中storyboardID名称
 */
@property (nonatomic, strong) NSString *storyboardID;
/**
 *  进入此界面需要先登陆
 */
@property (nonatomic) BOOL needLogin;
/**
 *  是否模态
 */
@property (nonatomic) BOOL model;
/**
 *  是否为TabBar 根视图
 */
@property (nonatomic) BOOL isTBC;
/**
 *  跳转TabBar视图 index
 */
@property (nonatomic,assign) NSInteger selectedIndex;
/**
 * 模态的方式
 */
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

@end
