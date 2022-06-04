//
//  NSDate+FMT.m
//  worklog
//
//  Created by RichardNie on 2022/6/3.
//

#import "NSDate+FMT.h"
#import <UIKit/UIKit.h>

@implementation NSDate (FMT)

//从字符串获取日期，默认格式yyyy-MM-dd(分隔符来自dateString)，或yyyyMMdd
+ (NSDate * __nullable)dateWithString:(NSString * __nullable)dateString withFormat:(NSString *)formatString {
    if(formatString == nil) {
        if(dateString.length == 10) {
            NSString *seperator = [dateString substringWithRange:NSMakeRange(4, 1)];
            formatString = [NSString stringWithFormat:@"yyyy%@MM%@dd", seperator, seperator];
        }
        else
            formatString = @"yyyyMMdd";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
    [formatter setTimeZone:zone];
    //变回日期格式
    NSDate *stringDate = [formatter dateFromString:dateString];
    return stringDate;
}

//日期格式化为字符串，默认格式yyyy-MM-dd
+ (NSString * __nullable)dateToString:(NSDate * __nullable)date withFormat:(NSString *)formatString {
    if(formatString == nil)
        formatString = @"yyyy-MM-dd";
    //设置日期格式
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat: formatString];
    //变为数字
    NSString* str = [formatter1 stringFromDate:date];
    return str;
}

//从整形数获取日期，8位长度，如：yyyyMMdd
+ (NSDate * __nullable)dateWithInteger:(NSInteger)num {
    return [NSDate dateWithString:[NSString stringWithFormat:@"%ld",num] withFormat:@"yyyyMMdd"];
}

//日期转整形数，8位长度，如：yyyyMMdd
+ (NSInteger)dateToInteger:(NSDate * __nullable)date {
    return [[NSDate dateToString:date withFormat:@"yyyyMMdd"] integerValue];
}

//日期增减 年 月 日，+增-减
+ (NSDate * __nullable)date:(NSDate * __nullable)date addYears:(long)years Month:(long)months addDays:(long)days {
    NSCalendar *calendar = nil;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [dateComponents setYear: years];
    [dateComponents setMonth: months];
    [dateComponents setDay: days];
    
    return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}

@end
