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

    NSCalendar *calendar             = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    // first 2016-10-18 9:10:11
    [dateComponents setYear:2016];
    [dateComponents setMonth:10];
    [dateComponents setDay:18];
    [dateComponents setHour:9];
    [dateComponents setMinute:10];
    [dateComponents setSecond:11];
    
    self.first = [calendar dateFromComponents:dateComponents];

    // second 2016-10-18 10:11:12
    [dateComponents setYear:2016];
    [dateComponents setMonth:10];
    [dateComponents setDay:18];
    [dateComponents setHour:10];
    [dateComponents setMinute:11];
    [dateComponents setSecond:12];
    
    self.second = [calendar dateFromComponents:dateComponents];
    
    // yesterday 2016-10-17 12:13:14
    [dateComponents setYear:2016];
    [dateComponents setMonth:10];
    [dateComponents setDay:17];
    [dateComponents setHour:12];
    [dateComponents setMinute:13];
    [dateComponents setSecond:14];
    
    self.yesterday = [calendar dateFromComponents:dateComponents];

    // tomorrow 2016-10-19 04:05:06
    [dateComponents setYear:2016];
    [dateComponents setMonth:10];
    [dateComponents setDay:19];
    [dateComponents setHour:4];
    [dateComponents setMinute:5];
    [dateComponents setSecond:6];
    
    self.tomorrow = [calendar dateFromComponents:dateComponents];
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
