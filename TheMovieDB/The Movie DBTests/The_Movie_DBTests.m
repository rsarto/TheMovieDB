//
//  The_Movie_DBTests.m
//  The Movie DBTests
//
//  Created by Ricardo Sarto on 10/3/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Helper.h"

@interface The_Movie_DBTests : XCTestCase

@property (nonatomic) NSDate* first;
@property (nonatomic) NSDate* second;
@property (nonatomic) NSDate* yesterday;
@property (nonatomic) NSDate* tomorrow;

@end

@implementation The_Movie_DBTests

- (void)setUp {
    [super setUp];
    NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // first 2016-10-18 9:10:11
    self.first = [calendar dateWithEra:1 year:2016 month:10 day:18 hour:9 minute:10 second:11 nanosecond:0];
    
    // second 2016-10-18 10:11:12
    self.second = [calendar dateWithEra:1 year:2016 month:10 day:18 hour:10 minute:11 second:12 nanosecond:0];
    
    // yesterday 2016-10-17 12:13:14
    self.yesterday = [calendar dateWithEra:1 year:2016 month:10 day:17 hour:12 minute:13 second:14 nanosecond:0];
    
    // tomorrow 2016-10-19 04:05:06
    self.tomorrow = [calendar dateWithEra:1 year:2016 month:10 day:19 hour:4 minute:5 second:6 nanosecond:0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCompareDates {
    // testing dates not considering hour
    XCTAssertFalse([Helper isDateGreaterNoHour:self.first than:self.first]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.second than:self.second]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.yesterday than:self.yesterday]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.yesterday than:self.tomorrow]);

    XCTAssertFalse([Helper isDateGreaterNoHour:self.second than:self.first]);

    XCTAssertFalse([Helper isDateGreaterNoHour:self.first than:self.second]);

    XCTAssertTrue([Helper isDateGreaterNoHour:self.tomorrow than:self.yesterday]);
    XCTAssertTrue([Helper isDateGreaterNoHour:self.tomorrow than:self.first]);
    XCTAssertTrue([Helper isDateGreaterNoHour:self.tomorrow than:self.second]);

    XCTAssertTrue([Helper isDateGreaterNoHour:self.first than:self.yesterday]);
    XCTAssertTrue([Helper isDateGreaterNoHour:self.second than:self.yesterday]);

    XCTAssertFalse([Helper isDateGreaterNoHour:self.yesterday than:self.tomorrow]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.yesterday than:self.first]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.yesterday than:self.second]);

    XCTAssertFalse([Helper isDateGreaterNoHour:self.first than:self.tomorrow]);
    XCTAssertFalse([Helper isDateGreaterNoHour:self.second than:self.tomorrow]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
