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

+ (instancetype)annotationWithObject:(id)object {
    YouBikeAnnotation *annotation = [[self alloc] init];
    
    if (annotation) {
        annotation.object = object;
        annotation.title = object[@"name_tw"];
        
        float lat = [object[@"lat"] floatValue];
        float lng = [object[@"lng"] floatValue];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    }
    
    return annotation;
}

@end
