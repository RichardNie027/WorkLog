//
//  NSDate+FMT.h
//  worklog
//
//  Created by RichardNie on 2022/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (FMT)

//从字符串获取日期，默认格式yyyy-MM-dd(分隔符来自dateString)，或yyyyMMdd
+ (NSDate * __nullable)dateWithString:(NSString * __nullable)dateString withFormat:(NSString *)formatString;

//日期格式化为字符串，默认格式yyyy-MM-dd
+ (NSString * __nullable)dateToString:(NSDate * __nullable)date withFormat:(NSString *)formatString;

//从整形数获取日期，8位长度，如：yyyyMMdd
+ (NSDate * __nullable)dateWithInteger:(NSInteger)num;

//日期转整形数，8位长度，如：yyyyMMdd
+ (NSInteger)dateToInteger:(NSDate * __nullable)date;

//日期增减 年 月 日，+增-减
+ (NSDate * __nullable)date:(NSDate * __nullable)date addYears:(long)years Month:(long)months addDays:(long)days;

@end

NS_ASSUME_NONNULL_END
