//
//  YouBikeTests.m
//  YouBikeTests
//
//  Created by 龐達業 on 2022/3/13.
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTest.h>
#import "NSObject+ObjectMapper.h"
#import "YouBikeStop.h"


@interface YouBikeTests : XCTestCase

@property (nonatomic, strong) NSArray *youbikeStops;

@end

@implementation YouBikeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSURL *url = [NSBundle.mainBundle URLForResource:@"YouBikeData" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.youbikeStops = [YouBikeStop mapObjectWithDictionary:dictionary];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    for (YouBikeStop *stop in self.youbikeStops) {
        NSLog(@"%f", stop.lat);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
