//
//  YouBikeMapViewController.m
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import "YouBikeMapViewController.h"
#import "NSObject+ObjectMapper.h"
#import "YouBikeSearchResultTableViewController.h"
#import "YouBikeAnnotation.h"
#import "YouBikeStopDetailView.h"

@interface YouBikeMapViewController ()

@property (nonatomic, strong) YouBikeSearchResultTableViewController *searchResultController;
@property (nonatomic) YouBikeStopDetailView *detailView;

@end


@implementation YouBikeMapViewController

@synthesize mapView, detailView;
@synthesize searchController, searchResultController;
@synthesize segmentedControl, selectedType;
@synthesize youbikeData, stops, stopKeyTable, YouBikeData;

- (void)dealloc {
    NSLog(@"YouBikeMapViewController dealloc");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedType = 1;
    
    self.title = @"YouBike";
    self.definesPresentationContext = YES;
    
    [self configureAppearance];
    [self setupSearchController];
    [self setupSegmentedControl];
    [self setupToolBar];
    [self setupMapView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *url = [NSBundle.mainBundle URLForResource:@"YoubikeData" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        self.youbikeData = [YouBikeStop mapObjectWithDictionary:dictionary[@"retVal"]];
//        [self createAnnotations:self.youbikeData];
        self.YouBikeData = dictionary[@"retVal"];
        [self createAnnotationsWithObject:self.YouBikeData];
    });
}

- (void)configureAppearance {
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    self.navigationItem.scrollEdgeAppearance = appearance;
}

- (void)setupSearchController {
    searchResultController = [[YouBikeSearchResultTableViewController alloc]init];
    searchResultController.mapViewController = self;
    
    searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultController];
    searchController.searchBar.delegate = searchResultController;
    searchController.searchResultsUpdater = searchResultController;
    [searchController setShowsSearchResultsController:YES];
    [searchController setObscuresBackgroundDuringPresentation:NO];
    [searchController.searchBar setPlaceholder:@"Search YouBike Stations"];
    
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
}

- (void)setupSegmentedControl {
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1.0", @"2.0"]];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
}

- (void)setupMapView {
    mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mapView.delegate = self;
    [mapView registerClass:[YouBikeStop class] forAnnotationViewWithReuseIdentifier:@"POINT"];
    
    [self.view addSubview:mapView];
    
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)setupToolBar {
    UIImage *starImage = [[UIImage systemImageNamed:@"star.fill"] imageWithTintColor:[UIColor systemYellowColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
#warning: set selector...
    UIBarButtonItem *starButton = [[UIBarButtonItem alloc] initWithImage:starImage style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:starButton];
}

- (void)dismiss:(UIBarButtonItem *)sender {
    if (self.presentingViewController) {
        id selected = [mapView.selectedAnnotations firstObject];
        [mapView deselectAnnotation:selected animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)segmentedIndexChanged:(UISegmentedControl *)sender {
    [searchController.searchBar setText:@""];
    selectedType = sender.selectedSegmentIndex + 1;
    
    [mapView removeAnnotations:mapView.annotations];
    NSLog(@"youbikeData: %lu", YouBikeData.count);
//    [self createAnnotations:youbikeData];
    [self createAnnotationsWithObject:YouBikeData];
}

- (void)createAnnotations:(NSArray *)stops {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.stopKeyTable = [NSMutableDictionary dictionaryWithCapacity:stops.count];
        NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:stops.count];
        
        NSLog(@"stops: %lu", stops.count);
        
        for (YouBikeStop *stop in stops) {
            if (stop.type != self.selectedType)
                continue;
            
            YouBikeAnnotation *annotation = [YouBikeAnnotation annotationWithStop:stop];
            [annotations addObject:annotation];
            self.stopKeyTable[stop.station_no] = annotation;
        }
        
        NSLog(@"annotations: %lu", annotations.count);
        self.stops = annotations;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:annotations];
        });
    });
    
}

- (void)createAnnotationsWithObject:(NSArray *)stops {
    
    if (!stopKeyTable)
        stopKeyTable = [NSMutableDictionary dictionaryWithCapacity:stops.count];
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:stops.count];
    NSLog(@"stops: %lu", stops.count);
    short type = selectedType;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (id stop in stops) {
            if ([stop[@"type"] shortValue] != type)
                continue;
            
            YouBikeAnnotation *annotation = [YouBikeAnnotation annotationWithObject:stop];
            [annotations addObject:annotation];
            self.stopKeyTable[stop[@"station_no"]] = annotation;
        }
        
        NSLog(@"annotations: %lu", annotations.count);
        self.stops = annotations;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:annotations];
        });
    });
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    YouBikeAnnotation *annotation = (YouBikeAnnotation *)view.annotation;
    YouBikeStop *stop = [YouBikeStop mapObjectWithDictionary:annotation.object];
    detailView = [[YouBikeStopDetailView alloc] initWithStop:stop];
    
    [UIView transitionWithView:self.view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:self.detailView];
    } completion:nil];
    
    detailView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [detailView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-28],
        [detailView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [detailView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [detailView.heightAnchor constraintEqualToConstant:100]
    ]];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [UIView transitionWithView:self.view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.detailView removeFromSuperview];
    } completion:nil];
}

@end
