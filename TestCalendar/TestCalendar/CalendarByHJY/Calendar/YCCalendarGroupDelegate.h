//
//  YCCalendarGroupDelegate.h
//  TestCalendar
//
//  Created by JyHu on 15/3/6.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCCalendarGroupView;
@class YCCalendarDayItem;

@protocol YCCalendarGroupDelegate <NSObject>

/**
 *  @author JyHu, 15-03-06 17:03:17
 *
 *  @brief  当点击一个按钮后，之前点击的按钮要被取消选择状态
 *
 *  @param calendarGroup 当前的日历控件
 *  @param dayItem       选择的日子所在的按钮
 */
- (void)calendarGroup:(YCCalendarGroupView *)calendarGroup didDeSelectedDayItem:(YCCalendarDayItem *)dayItem;

/**
 *  @author JyHu, 15-03-06 17:03:12
 *
 *  @brief  当日历滚动结束的时候
 *
 *  @param calendarGroup 当前的日历控件
 */
- (void)calendarGroupDidScrollingEnd:(YCCalendarGroupView *)calendarGroup;

@end


@interface YCCalendarGroupDelegate : NSObject

@end
