//
//  YCDateExtension.h
//  Shecare
//
//  Created by JyHu on 15-1-8.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//


/**
 * @brief 时间的处理方法扩充
 *
 * @date 2015-01-08
 *
 * @version V <#version#>
 *
 * @author ikangtai JyHu
 *
 * @copyright Beijing ikangtai Technology Inc
 *
 */


#import <Foundation/Foundation.h>


#define kYC_DAY_TIME_INTERVAL  (24 * 60 * 60)


@interface NSDate(YCDateExtension)

/**
 *  @author JyHu, 15-01-22 14:01:14
 *
 *  @brief  获取当前日期的年份
 */
@property (assign, nonatomic, readonly) NSInteger year;

/**
 *  @author JyHu, 15-01-08 18:01:20
 *
 *  @brief  获取当前日期的月份
 */
@property (assign, nonatomic, readonly) NSInteger month;

/**
 *  @author JyHu, 15-01-08 18:01:32
 *
 *  @brief  获取当前日期的日子
 */
@property (assign, nonatomic, readonly) NSInteger day;

/**
 *  @author JyHu, 15-01-08 18:01:46
 *
 *  @brief  获取当前日期的小时
 */
@property (assign, nonatomic, readonly) NSInteger hour;

/**
 *  @author JyHu, 15-01-08 18:01:00
 *
 *  @brief  获取当前日期的分钟
 */
@property (assign, nonatomic, readonly) NSInteger minute;

/**
 *  @author JyHu, 15-01-08 18:01:11
 *
 *  @brief  获取当前日期的秒数
 */
@property (assign, nonatomic, readonly) NSInteger seconds;

/**
 *  @author JyHu, 15-01-09 17:01:32
 *
 *  @brief  获取一个日期是周几
 *
 *  @return 星期的字符串
 */
- (NSString *)weekdayString;

/**
 *  @author JyHu, 15-01-22 13:01:55
 *
 *  @brief  计算当前日期月份有多少天
 *
 *  @return 天数
 */
- (NSInteger)daysOfMonth;

/**
 *  @author JyHu, 15-01-22 14:01:58
 *
 *  @brief  一天的凌晨刚开始
 *
 *  @return 凌晨时间
 */
- (NSDate *)dayBegin;

/**
 *  @author JyHu, 15-01-22 14:01:22
 *
 *  @brief  一天的结束
 *
 *  @return 一天最后的时间
 */
- (NSDate *)dayEnd;

/**
 *  @author JyHu, 15-01-22 14:01:15
 *
 *  @brief  月初
 *
 *  @return 月初
 */
- (NSDate *)monthBegin;

/**
 *  @author JyHu, 15-01-22 14:01:14
 *
 *  @brief  将时间字符串格式化成OC中的时间对象
 *
 *  @param yyyyMMddHHmmss 时间字符串
 *
 *  @return 格式化后的时间
 */
- (NSDate *)dateWithyyyyMMddHHmmssString:(NSString *)yyyyMMddHHmmss;

/**
 *  @author JyHu, 15-01-22 14:01:12
 *
 *  @brief  当前日期所在的月份第一天是周几
 *
 *  @return 周几，0-周日，1-周一，2-周二，3-周三 。。。
 */
- (NSInteger)firstDayWeekOfCurMonth;

/**
 *  @author JyHu, 15-01-22 14:01:40
 *
 *  @brief  当前日期的上一个月份的月初
 *
 *  @return 上一月
 */
- (NSDate *)lastMonth;

/**
 *  @author JyHu, 15-01-22 14:01:42
 *
 *  @brief  当前日期的下一月的月初
 *
 *  @return 下一月
 */
- (NSDate *)nextMonth;

+ (NSDate *)dateWithyyyyMMddString:(NSString *)yyyyMMddString;

- (NSString *)yyyyMMddString;

@end
