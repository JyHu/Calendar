//
//  YCSolarHoliday.h
//  TestCalendar
//
//  Created by JyHu on 15/3/9.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCSolarHoliday : NSObject

@property (assign, nonatomic) NSInteger month;

@property (assign, nonatomic) NSInteger day;

@property (assign, nonatomic) NSInteger recess;

@property (retain, nonatomic) NSString *holidayName;

@end
