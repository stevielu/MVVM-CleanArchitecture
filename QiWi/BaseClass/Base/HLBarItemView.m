//
//  HLBarItemView.m
//  HLSmartWay
//
//  Created by wei lu on 20/05/18.
//  Copyright © 2018 HualiTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBarItemView.h"

@interface HLBarItemView()

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) HLBarItemActionBlock actionBlock;

@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGFloat titleWidth;
@end

@implementation HLBarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles actionBlock:(HLBarItemActionBlock)actionBlock {
    return [self initWithTitles:titles titleWidth:33 padding:20 withBgView:nil actionBlock:actionBlock];
}

- (instancetype)initWithTitles:(NSArray *)titles titleWidth:(CGFloat)width actionBlock:(HLBarItemActionBlock)actionBlock {
    return [self initWithTitles:titles titleWidth:width padding:20  withBgView:nil actionBlock:actionBlock];
}

- (instancetype)initWithTitles:(NSArray *)titles titleWidth:(CGFloat)width withBgView:(UIView *)view actionBlock:(HLBarItemActionBlock)actionBlock {
    return [self initWithTitles:titles titleWidth:width padding:20 withBgView:view actionBlock:actionBlock];
}

- (instancetype _Nonnull)initWithTitles:(NSArray * _Nonnull)titles titleWidth:(CGFloat)width padding:(CGFloat)padding withBgView:(UIView *)view actionBlock:(HLBarItemActionBlock _Nullable)actionBlock {
    self = [super init];
    if (self) {
        self.titles = titles;
        self.padding = padding;
        self.titleWidth = width;
        self.frame = [self configView];
        
        self.actionBlock = actionBlock;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (CGRect)configView {
    return [self configView:nil];
}

- (CGRect)configView:(UIView *)withView {
    if (!self.titles || self.titles.count == 0) {
        return CGRectZero;
    }
    __block CGFloat x = self.frame.origin.x;
    __block NSMutableArray *titleBtns = [NSMutableArray array];
    WEAK_SELF;
    [self.titles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x + self.titleWidth * idx, 0, self.titleWidth, 44)];
        [self addSubview:button];
        
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(onpressedClickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        if (idx == 0) {
            button.selected = true;
        }
        
        [titleBtns addObject:button];
        x = x + self.padding;
    }];
    
    self.titleBtns = titleBtns;
    return CGRectMake(0, 0, (self.titles.count * self.titleWidth + (self.titles.count - 1) * self.padding), 44);
}

- (void)onpressedClickButton:(UIButton *)button {
    if (self.actionBlock) {
        self.actionBlock(button);
    }
}

@end
