//
//  HLHelper.m
//  HLSmartWay
//
//  Created by stevie on 2018/5/28.
//  Copyright © 2018年 HualiTec. All rights reserved.
//

#import "HLHelper.h"

#import "NSDate+Utilities.h"

@implementation HLHelper


+ (NSString *)fullDateToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}
+ (NSString *)fullDate1ToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}

+ (NSString *)fullDate2ToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}

+ (NSString *)releaseFullDateToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}

+ (NSString *)shortDate2ToString:(NSDate *)date {
    
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDate *now = [NSDate date];
    
    if ([now timeIntervalSinceDate:date] <= 15) {
        [dateFormatter setDateFormat:@"Just"];
    }
    else if ([now timeIntervalSinceDate:date] <= 30) {
        [dateFormatter setDateFormat:@"30s ago"];
    }
    else if ([now minutesAfterDate:date] <= 30) {
        NSInteger minutes = [now minutesAfterDate:date] + 1;
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@m ago", @(minutes)]];
    }
    else if ([now hoursAfterDate:date] <= 12) {
        NSInteger hours = [now hoursAfterDate:date] + 1;
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@h ago", @(hours)]];
    }
    else {
        NSInteger days = ABS([now distanceInDaysToDate:date] - 1);
        if (days < 30) {
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@day before", @(days)]];
        }else {
            [dateFormatter setDateFormat:@"1m before"];
        }
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
    
}
+ (NSString *)shortDate1ToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDate *now = [NSDate date];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    if ([now timeIntervalSinceDate:date] <= 15) {
        //[dateFormatter setDateFormat:@"just"];
        return @"Just";
    }
    else if ([now timeIntervalSinceDate:date] <= 30) {
        //[dateFormatter setDateFormat:@"30s ago"];
        return @"30s ago";
    }
    else if ([now minutesAfterDate:date] <= 30) {
        NSInteger minutes = [now minutesAfterDate:date] + 1;
        //[dateFormatter setDateFormat:[NSString stringWithFormat:@"%@m ago", @(minutes)]];
        return [NSString stringWithFormat:@"%@m ago", @(minutes)];
    }
    else if ([now hoursAfterDate:date] <= 12) {
        NSInteger hours = [now hoursAfterDate:date] + 1;
        return [NSString stringWithFormat:@"%@h ago", @(hours)];
        //[dateFormatter setDateFormat:[NSString stringWithFormat:@"%@h ago", @(hours)]];
    }
    else if ([date isToday]) {
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        //[dateFormatter setDateFormat:@"Today HH:mm"];
    }
    else if ([date isYesterday]) {
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        //[dateFormatter setDateFormat:@"Yesterday HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
//    dateFormatter.doesRelativeDateFormatting = YES;
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}

+ (NSString *)shortDate1FromString:(NSString *)date withTimeZone:(NSTimeZone *) timezone
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if(timezone){
        [dateFormatter setTimeZone:timezone];
    }else{
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    NSDate *value = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    if(timezone){
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }else{
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:value];
    return currentDateStr ?: @" ";
}

+ (NSString *)shortDate1FromString:(NSString *)date
{
    NSTimeZone *timeZone = [self timeZoneFromOffset:[HLGlobalValue sharedInstance].timeZone];
    
    return [self shortDate1FromString:date withTimeZone:timeZone];
}

+ (NSDate *)shortDate2FromString:(NSString *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *myDate = [formatter dateFromString:date];
    NSDateComponents *myDateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:myDate];
    todayComponents.minute = myDateComponents.minute;
    todayComponents.hour = myDateComponents.hour;
    NSDate *myCompleteDate = [calendar dateFromComponents:todayComponents];
    

    return myCompleteDate;
}

+ (NSDate *)shortDate3FromString:(NSString *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSTimeZone *timeZone = [self timeZoneFromOffset:[HLGlobalValue sharedInstance].timeZone];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if(timeZone){
        [dateFormatter setTimeZone:timeZone];
    }else{
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    NSDate *value = [dateFormatter dateFromString:date];
    
    NSInteger offset = [value offsetInHoursToTimeZone:[NSTimeZone localTimeZone]];
    return [NSDate dateWithTimeInterval:offset sinceDate:value];
}

+ (NSDate *)combineDate:(NSString *)ddmmyy hhmm:(NSString *)content withTimeZone:(NSTimeZone *)timezone
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:timezone];
    NSDate *value = [dateFormatter dateFromString:ddmmyy];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:timezone];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:value];
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *myDate = [dateFormatter dateFromString:content];
    NSDateComponents *myDateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:myDate];
    
    todayComponents.minute = myDateComponents.minute;
    todayComponents.hour = myDateComponents.hour;
    NSDate *myCompleteDate = [calendar dateFromComponents:todayComponents];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * result = [dateFormatter stringFromDate:myCompleteDate];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    myCompleteDate = [dateFormatter dateFromString:result];
    return myCompleteDate;
}

+ (NSString *)shortDateToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDate *now = [NSDate date];
    
    if ([now timeIntervalSinceDate:date] <= 15) {
        [dateFormatter setDateFormat:@"just"];
    }
    else if ([now timeIntervalSinceDate:date] <= 30) {
        [dateFormatter setDateFormat:@"30s ago"];
    }
    else if ([now minutesAfterDate:date] <= 30) {
        NSInteger minutes = [now minutesAfterDate:date] + 1;
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@m ago", @(minutes)]];
    }
    else if ([now hoursAfterDate:date] <= 12) {
        NSInteger hours = [now hoursAfterDate:date] + 1;
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@h ago", @(hours)]];
    }
    else if ([date isToday]) {
        [dateFormatter setDateFormat:@"Today HH:mm"];
    }
    else if ([date isYesterday]) {
        [dateFormatter setDateFormat:@"Yesterday HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}


+ (NSString *)shortDate3ToString:(NSNumber *)date {
    
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDate *now = [NSDate date];
    NSDate *timeStap = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    if ([now minutesBeforeDate:timeStap] <= 30) {
        NSInteger minutes = [now minutesBeforeDate:timeStap] + 1;
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@m later", @(minutes)]];
    }else{
        [dateFormatter setDateFormat:@"HH:mm"];
    }

    
    NSString *currentDateStr = [dateFormatter stringFromDate:timeStap];
    return currentDateStr;
    
}

+ (NSString *)longDateToString:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if ( ! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDate *now = [NSDate date];
    
    if ([date isToday]) {
        [dateFormatter setDateFormat:@"Today HH:mm"];
    }
    else if ([date isYesterday]) {
        [dateFormatter setDateFormat:@"Yesterday HH:mm"];
    }
    else {
        NSInteger days = ABS([now distanceInDaysToDate:date] - 1);
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@days before", @(days)]];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr ?: @" ";
}

+ (NSTimeZone *)timeZoneFromOffset:(NSString *)GMTValue
{
//    NSString *op = [GMTValue substringToIndex:0];
//
//    float value = [[GMTValue substringFromIndex:1] floatValue];
    if(!GMTValue){
        return [NSTimeZone localTimeZone];
    }
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSString *equation = [NSString stringWithFormat:@"(0 %@) * 3600",GMTValue];
    NSExpression *expr = [NSExpression expressionWithFormat:equation];
    NSNumber *result = [expr expressionValueWithObject:nil context:nil];
    timeZone = [NSTimeZone timeZoneForSecondsFromGMT:result.integerValue];
    return timeZone;
}

+ (NSDate *)dateWithOffset:(NSDate *)from offset:(NSString *)GMTValue
{
    NSTimeZone *serverTimeZone = [self timeZoneFromOffset:GMTValue];
    
    NSDate *result = [[NSDate alloc] init];
    NSInteger offset = [result offsetInHoursToTimeZone:serverTimeZone];
    if (offset > 0){
        result = [from dateByAddingHours:offset];
    }else if (offset < 0){
        result = [from dateBySubtractingHours:offset];
    }
    
    return result;
}

+ (NSString *)countToString:(NSNumber *)count
{
    if (count.integerValue < 1000) {
        return [NSString stringWithFormat:@"%@ Words", count];
    }
    else if (count.integerValue < 10000) {
        CGFloat temp = count.floatValue;
        temp /= 1000;
        return [NSString stringWithFormat:@"%.1fk Words", temp];
    }
    else {
        CGFloat temp = count.floatValue;
        temp /= 10000;
        return [NSString stringWithFormat:@"%.1f0k Words", temp];
    }
}

+ (NSString *)countToShortString:(NSNumber *)count
{
    count = count ?: @0;
    if (count.integerValue < 10000) {
        return [NSString stringWithFormat:@"%@", count];
    }
    else {
        CGFloat temp = count.floatValue;
        temp /= 10000;
        return [NSString stringWithFormat:@"%.1f0k", temp];
    }
}

+ (NSAttributedString *)attributedStringWithText:(NSString *)text image:(NSString *)image {
    
    NSMutableAttributedString *mutableAttribute = [[NSMutableAttributedString alloc]init];
    NSMutableDictionary *attriDic = @{}.mutableCopy;
    //    attriDic[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    //    attriDic[NSForegroundColorAttributeName] = HRGB(0x333333);
    
    if (image) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        attachment.image = [UIImage imageNamed:image];
        NSAttributedString *imageAttribute = [NSAttributedString attributedStringWithAttachment:attachment];
        attachment.bounds = CGRectMake(0, 0, 15, 13);
        [mutableAttribute appendAttributedString:imageAttribute];
        attriDic[NSBaselineOffsetAttributeName] = @(2);
    }
    
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",text] attributes:attriDic];
    [mutableAttribute appendAttributedString:textAttr];
    
    return mutableAttribute.copy;
}

+ (NSString *)phoneNumberWithState:(NSString *)state phone:(NSString *)phone {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:state options:0 range:NSMakeRange(0, state.length)];
    if (match) {
        state = [state substringWithRange:match.range];
    }
    if ( ! [state isEqualToString:@"86"]) {
        phone = [NSString stringWithFormat:@"%@%@", state, phone];
    }
    return phone;
}

+ (NSString *)gmsRequestWithWaypoint:(NSMutableArray<CLLocation *> *)locations{
    NSString *url = @"";
    for (CLLocation *item in locations) {
        NSString *formatter = @"%f,%f|";
        if([locations lastObject] == item){
            formatter = @"%f,%f";
        }
        url = [url stringByAppendingString:[NSString stringWithFormat:formatter,item.coordinate.latitude,item.coordinate.longitude]];
    }
    return url;
}
@end
