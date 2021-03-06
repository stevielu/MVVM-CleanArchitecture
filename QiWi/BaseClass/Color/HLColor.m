//
//  HLColor.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/3.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLColor.h"

@implementation UIColor (HL)

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:(CGFloat)(arc4random() % 256) / 255 green:(CGFloat)(arc4random() % 256) / 255 blue:(CGFloat)(arc4random() % 256) / 255 alpha:1.f];
}

+ (UIColor *)colorF9
{
    return HRGB(0xF9F9F9);
}

+ (UIColor *)colorF4
{
    return HRGB(0xF4F4F4);
}

+ (UIColor *)colorDC
{
    return HRGB(0xDCDCDC);
}

+ (UIColor *)colorAE
{
    return HRGB(0xAEAEAE);
}

+ (UIColor *)color84
{
    return HRGB(0x848484);
}

+ (UIColor *)color50
{
    return HRGB(0x505050);
}

+ (UIColor *)color55
{
    return HRGB(0x505050);
}

+ (UIColor *)color69
{
    return HRGB(0x695047);
}


+ (UIColor *)colorF1
{
    return HRGB(0xF1F1F1);
}
+ (UIColor *)color33 {
    return HRGB(0x333333);
}

+ (UIColor *)colorHLBlue
{
    return HRGB(0x2C63FF);
}

+ (UIColor *)colorHLBlueDark
{
    return HRGB(0x0839D0);
}

+ (UIColor *)colorHLBlueTransparent
{
    return HRGB(0xFB93B6);
}

+ (UIColor *)colorDD
{
    return HRGB(0xDDDDDD);
}
+ (UIColor *)colorFA
{
    return HRGB(0xFA8E9B);
}
+ (UIColor *)colorFE
{
    return HRGB(0xFEA598);
}
+ (UIColor *)colorF8
{
    return HRGB(0xF8F8F8);
}
+ (UIColor *)colorA6
{
    return HRGB(0xA66868);
}
+ (UIColor *)colorEE
{
    return HRGB(0xeeebeb);
}
+ (UIColor *)routeBlue
{
    return HRGB(0x2b99fb );
}
+ (UIColor *)routeLightBlue
{
    return HRGB(0x00f0ff );
}

+ (UIColor *)markerGolden
{
    return HRGB(0xFFBF00 );
}
@end
