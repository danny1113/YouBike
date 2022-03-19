//
//  YouBikeAnnotation.m
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import "YouBikeAnnotation.h"

@implementation YouBikeAnnotation

+ (instancetype)annotationWithStop:(YouBikeStop *)stop {
    YouBikeAnnotation *annotation = [[self alloc] init];
    
    if (annotation) {
        annotation.stop = stop;
        annotation.title = stop.name_tw;
        annotation.coordinate = CLLocationCoordinate2DMake(stop.lat, stop.lng);
    }
    
    return annotation;
}

@end
