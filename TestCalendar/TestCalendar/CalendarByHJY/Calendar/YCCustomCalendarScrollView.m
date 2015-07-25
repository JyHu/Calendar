//
//  YCCustomCalendarScrollView.m
//  TestCalendar
//
//  Created by JyHu on 15/3/6.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "YCCustomCalendarScrollView.h"

@implementation YCCustomCalendarScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch *touch = [touches anyObject];
    
    if (touch.phase == UITouchPhaseMoved)
    {
        return NO;
    }
    
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

@end
