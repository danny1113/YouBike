//
//  YouBikeAnnotation.h
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import <MapKit/MapKit.h>

#import "YouBikeStop.h"

NS_ASSUME_NONNULL_BEGIN

@interface YouBikeAnnotation : MKPointAnnotation

@property (nonatomic, strong) YouBikeStop *stop;

+ (instancetype)annotationWithStop:(YouBikeStop *)stop;

@end

NS_ASSUME_NONNULL_END
