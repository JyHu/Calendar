//
//  YCCalendarDelegate.h
//  TestCalendar
//
//  Created by JyHu on 15/3/6.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCCalendarDayItem.h"


typedef struct{
    CGFloat topSpacing;
    CGFloat bottomSpacing;
    CGFloat leftSpacing;
    CGFloat rightSpacing;
    CGFloat elementsSpacing;
} YCCalendarSpacingControl;

/* spacing control in calendar */
CG_INLINE YCCalendarSpacingControl YCCalendarSpacingControlMake(CGFloat topSpacing,
                                                                CGFloat bottomSpacing,
                                                                CGFloat leftSpacing,
                                                                CGFloat rightSpacing,
                                                                CGFloat elementsSpacing);

/* make a spacing control */
CG_INLINE YCCalendarSpacingControl YCCalendarSpacingControlMake(CGFloat topSpacing,
                                                                CGFloat bottomSpacing,
                                                                CGFloat leftSpacing,
                                                                CGFloat rightSpacing,
                                                                CGFloat elementsSpacing)
{
    YCCalendarSpacingControl spacingControl;
    
    spacingControl.topSpacing       = topSpacing;
    spacingControl.bottomSpacing    = bottomSpacing;
    spacingControl.leftSpacing      = leftSpacing;
    spacingControl.rightSpacing     = rightSpacing;
    spacingControl.elementsSpacing  = elementsSpacing;
    
    return spacingControl;
}

@class YCCalendarView;

@protocol YCCalendarDelegate <NSObject>

@required

/**
 *  @author JyHu, 15-03-05 11:03:39
 *
 *  @brief  设置日历的星期的高度
 *
 *  @param calendar 当前月份的日历
 *
 *  @return 高度
 */
- (CGFloat)heightForWeekTitleOfCalendar:(YCCalendarView *)calendar;

@optional

/**
 *  @author JyHu, 15-03-05 11:03:57
 *
 *  @brief  当点击日历上的按钮的时候的回调事件
 *
 *  @param calendar 当前月份的日历
 *  @param dayItem  日历上的日期的按钮
 */
- (void)calendar:(YCCalendarView *)calendar didSelectedDayItem:(YCCalendarDayItem *)dayItem;

/**
 *  @author JyHu, 15-03-05 11:03:25
 *
 *  @brief  给当前日历上的按钮上添加其他元素
 *
 *  @param calendar 当前月份的日历
 *  @param dayItem  日历上的日期的按钮
 */
- (void)calendar:(YCCalendarView *)calendar addElementsForDayItem:(YCCalendarDayItem *)dayItem;

/**
 *  @author JyHu, 15-03-05 11:03:52
 *
 *  @brief  日历上的星期的label
 *
 *  @param calendar   当前月份的日历
 *  @param weeksLabel 日历上的
 */
- (void)calendar:(YCCalendarView *)calendar weeksLabel:(UILabel *)weeksLabel;

/**
 *  @author JyHu, 15-03-05 11:03:57
 *
 *  @brief  生成一个控制日历上日期按钮间距的结构体
 *
 *  @param calendar 当前月份的日历
 *
 *  @return 间距控制的结构体
 */
- (YCCalendarSpacingControl)spacingControlForCalendar:(YCCalendarView *)calendar;

/**
 *  @author JyHu, 15-03-05 15:03:44
 *
 *  @brief  设置是否显示日期按钮上的日子
 *
 *  @param calendar 当前月份的日历
 *
 *  @return 是否显示
 */
- (BOOL)needShowDayItemTitleForCalendar:(YCCalendarView *)calendar;

@end

@interface YCCalendarDelegate : NSObject

@end
