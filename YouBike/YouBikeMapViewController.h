//
//  YouBikeMapViewController.h
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "YouBikeStop.h"


NS_ASSUME_NONNULL_BEGIN

@interface YouBikeMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic) short selectedType;


@property (nonatomic, strong) NSArray<YouBikeStop *> *youbikeData;
@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) NSMutableDictionary *stopKeyTable;

@end

NS_ASSUME_NONNULL_END
