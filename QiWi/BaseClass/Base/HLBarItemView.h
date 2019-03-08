//
//  HLBarItemView.h
//  HLSmartWay
//
//  Created by wei lu on 20/05/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBarItemView : UIView

typedef void (^HLBarItemActionBlock)(UIButton  * _Nullable btn);

@property (nonatomic, strong, nullable) NSArray *titleBtns;

- (instancetype _Nonnull)initWithTitles:(NSArray * _Nonnull )titles actionBlock:(HLBarItemActionBlock _Nullable)actionBlock;

- (instancetype _Nonnull)initWithTitles:(NSArray * _Nonnull)titles titleWidth:(CGFloat)width padding:(CGFloat)padding actionBlock:(HLBarItemActionBlock _Nullable)actionBlock;

- (instancetype)initWithTitles:(NSArray *)titles titleWidth:(CGFloat)width withBgView:(UIView *)view actionBlock:(HLBarItemActionBlock)actionBlock;

- (instancetype _Nonnull)initWithTitles:(NSArray *_Nonnull)titles titleWidth:(CGFloat)width actionBlock:(HLBarItemActionBlock)actionBlock;
@end

NS_ASSUME_NONNULL_END
