//
//  YouBikeStop.h
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YouBikeStop : NSObject

@property (nonatomic) short type;

@property (nonatomic) NSString *station_no;
@property (nonatomic) NSString *name_tw;
@property (nonatomic) NSString *district_tw;
@property (nonatomic) NSString *address_tw;
@property (nonatomic) NSString *name_en;
@property (nonatomic) NSString *district_en;
@property (nonatomic) NSString *address_en;

@property (nonatomic) NSInteger parking_spaces;
@property (nonatomic) NSInteger available_spaces;
@property (nonatomic) NSInteger empty_spaces;

@property (nonatomic) float lat;
@property (nonatomic) float lng;

@property (nonatomic) NSString *time;

@end

NS_ASSUME_NONNULL_END
