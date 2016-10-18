//
//  Helper.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/17/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "Helper.h"

@implementation Helper

//
// Compare dates without time
//
+ (BOOL) isDateGreaterNoHour:(NSDate*)date1 than:(NSDate*)date2 {
    NSCalendar *calendar   = [NSCalendar currentCalendar];
    
    return [calendar compareDate:date1
                          toDate:date2
               toUnitGranularity:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear] == NSOrderedDescending;
}


@end
