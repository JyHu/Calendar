//
//  YCCalendarViewController.m
//  TestCalendar
//
//  Created by JyHu on 15/3/5.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCCalendarViewController.h"
#import "YCCalendarView.h"
#import "YCCalendarGroupView.h"
#import "YCChineseCalendar.h"

@interface YCCalendarViewController ()<YCCalendarDelegate,YCCalendarGroupDelegate>

@property (retain, nonatomic) YCCalendarView *calendarView;

@property (retain, nonatomic) YCCalendarGroupView *calenarGroupView;

@property (retain, nonatomic) UILabel *dateLabel;

@property (retain, nonatomic) UILabel *selectedLabel;

@end

@implementation YCCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDate *d = [NSDate dateWithyyyyMMddString:@"2015-03-20"];
    
    YCDateTime date = solarDateToLunarDate(iOSDateToYCDate(d));

    NSLog(@"%@     %.4ld-%.2ld-%.2ld",d,date.year, date.month, date.day);
    
//    YCLunarDate *ld = lunarDate(date);
//    
//    NSLog(@"%@-%@-%@",ld.year, ld.month, ld.day);
    
//    _calendarView = [[YCCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44 - 60) date:d delegate:self];
//    _calendarView.backgroundColor = [UIColor clearColor];
//    _calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:_calendarView];
    
    _calenarGroupView = [[YCCalendarGroupView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44 - 60) date:d delegate:self];
//    _calenarGroupView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_calenarGroupView];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _calenarGroupView.frame.size.height + 84, self.view.frame.size.width, 30)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dateLabel];
    
    _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dateLabel.frame.origin.y + 50, self.view.frame.size.width, 30)];
    _selectedLabel.textAlignment = NSTextAlignmentCenter;
    _selectedLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_selectedLabel];
}

- (CGFloat)heightForWeekTitleOfCalendar:(YCCalendarView *)calendar
{
    return 18;
}

#pragma mark - calendar delegate

- (void)calendar:(YCCalendarView *)calendar didSelectedDayItem:(YCCalendarDayItem *)dayItem
{
    NSLog(@"%@     -    %d",dayItem.solarNSDate,dayItem.dayTypeOfMonth);
    
    self.selectedLabel.text = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld/%.4ld-%.2ld-%.2ld",dayItem.solarNSDate.year, dayItem.solarNSDate.month, dayItem.solarNSDate.day,dayItem.lunarDate.year, dayItem.lunarDate.month, dayItem.lunarDate.day];
}

- (void)calendar:(YCCalendarView *)calendar addElementsForDayItem:(YCCalendarDayItem *)dayItem
{
    dayItem.backgroundColor = [UIColor clearColor];
}

- (YCCalendarSpacingControl)spacingControlForCalendar:(YCCalendarView *)calendar
{
    return YCCalendarSpacingControlMake(0, 0, 10, 10, 3);
}


- (void)calendarGroupDidScrollingEnd:(YCCalendarGroupView *)calendarGroup
{
    NSLog(@"%@",calendarGroup.calendarDate);
    
    _dateLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",calendarGroup.calendarDate.year, calendarGroup.calendarDate.month, calendarGroup.calendarDate.day];
}

- (void)calendarGroup:(YCCalendarView *)calendar didDeSelectedDayItem:(YCCalendarDayItem *)dayItem
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
