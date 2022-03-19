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
@property (nonatomic) id object;

+ (instancetype)annotationWithStop:(YouBikeStop *)stop;
+ (instancetype)annotationWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
