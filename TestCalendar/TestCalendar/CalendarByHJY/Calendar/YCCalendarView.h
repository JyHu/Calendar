//
//  YCCalendarView.h
//  TestCalendar
//
//  Created by JyHu on 15/3/5.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCalendarDayItem.h"
#import "YCDateExtension.h"
#import "YCCalendarDelegate.h"

@interface YCCalendarView : UIView

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date delegate:(id<YCCalendarDelegate>)delegate;

@property (assign, nonatomic) CGFloat height;

@end

extern NSString *const tNotification_DidSelectedDayItem;