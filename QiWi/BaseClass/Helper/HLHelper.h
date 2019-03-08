//
//  HLHelper.h
//  HLSmartWay
//
//  Created by stevie on 2018/5/28.
//  Copyright © 2018年 HualiTec. All rights reserved.
//
#import <Foundation/Foundation.h> 
#import <CoreLocation/CoreLocation.h>

@interface HLHelper : NSObject
+ (NSString *)releaseFullDateToString:(NSDate *)date;

+ (NSString *)countToShortString:(NSNumber *)count;
+ (NSString *)fullDateToString:(NSDate *)date;  //xxxx年xx月xx日 xx:xx
+ (NSString *)fullDate1ToString:(NSDate *)date; //xxxx-xx-xx
+ (NSString *)fullDate2ToString:(NSDate *)date; //xxxx年xx月xx日

+ (NSString *)shortDateToString:(NSDate *)date;
+ (NSString *)shortDate1ToString:(NSDate *)date;
+ (NSString *)longDateToString:(NSDate *)date;
+ (NSString *)countToString:(NSNumber *)count;

+ (NSString *)shortDate2ToString:(NSDate *)date;
+ (NSString *)shortDate3ToString:(NSNumber *)date;
+ (NSString *)shortDate1FromString:(NSString *)date withTimeZone:(NSTimeZone *) timezone;
+ (NSString *)shortDate1FromString:(NSString *)date;
+ (NSDate *)shortDate2FromString:(NSString *)date;
+ (NSDate *)shortDate3FromString:(NSString *)date;

+ (NSDate *)combineDate:(NSString *)ddmmyy hhmm:(NSString *)content withTimeZone:(NSTimeZone *)timezone;
+ (NSDate *)dateWithOffset:(NSDate *)from offset:(NSString *)GMTValue;//offset to specfic time zone

+ (NSTimeZone *)timeZoneFromOffset:(NSString *)GMTValue;

+ (NSAttributedString *)attributedStringWithText:(NSString *)text image:(NSString *)image;


/**
 拼接正确的电话号码
 
 @param state 区号
 @param phone phone
 @return 电话号码
 */
+ (NSString *)phoneNumberWithState:(NSString *)state phone:(NSString *)phone;

/**
 拼接正确的Google Map 线路请求格式:xxx,xxx|xxx,xxx
 
 @param locations 区号
 @return waypoints请求url 格式
 */
+ (NSString *)gmsRequestWithWaypoint:(NSMutableArray<CLLocation *> *)locations;
@end
