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

@interface YouBikeMapViewController ()

@property (nonatomic, strong) YouBikeSearchResultTableViewController *searchResultController;

@end


@implementation YouBikeMapViewController

@synthesize mapView;
@synthesize searchController;
@synthesize segmentedControl;
@synthesize searchResultController;
@synthesize selectedType;
@synthesize youbikeData;
@synthesize stops;
@synthesize stopKeyTable;

- (void)dealloc {
    NSLog(@"YouBikeMapViewController dealloc");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"YoubikeData" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    youbikeData = [YouBikeStop mapObjectWithDictionary:dictionary[@"retVal"]];
    stops = [self createAnnotations:youbikeData];
    
    self.title = @"YouBike";
    self.definesPresentationContext = YES;
    selectedType = 1;
    
    [self configureAppearance];
    [self setupSearchController];
    [self setupSegmentedControl];
    [self setupToolBar];
    [self setupMapView];
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
    mapView = [MKMapView new];
    mapView.delegate = self;
    [mapView registerClass:[YouBikeStop class] forAnnotationViewWithReuseIdentifier:@"POINT"];
    [self.mapView addAnnotations:stops];
    
    [self.view addSubview:mapView];
    
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [[mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

- (void)setupToolBar {
    UIImage *starImage = [[UIImage systemImageNamed:@"star.fill"] imageWithTintColor:[UIColor systemYellowColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
#warning: set selector...
    UIBarButtonItem *starButton = [[UIBarButtonItem alloc] initWithImage:starImage style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:starButton];
}

- (void)dismiss:(UIBarButtonItem *)sender {
    if (self.presentingViewController != nil) {
        id selected = [mapView.selectedAnnotations firstObject];
        [mapView deselectAnnotation:selected animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)segmentedIndexChanged:(UISegmentedControl *)sender {
    [searchController.searchBar setText:@""];
    selectedType = sender.selectedSegmentIndex + 1;
    
    [mapView removeAnnotations:mapView.annotations];
    NSLog(@"youbikeData: %lu", youbikeData.count);
    NSArray *annotaions = [self createAnnotations:youbikeData];
    [mapView addAnnotations:annotaions];
}

- (NSArray *)createAnnotations:(NSArray *)stops {
    stopKeyTable = [NSMutableDictionary dictionaryWithCapacity:stops.count];
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:stops.count];
    
    NSLog(@"type: %hd", selectedType);
    for (YouBikeStop *stop in stops) {
        if (stop.type != selectedType)
            continue;
        
        YouBikeAnnotation *annotation = [YouBikeAnnotation new];
        annotation.stop = stop;
        annotation.title = stop.name_tw;
        annotation.coordinate = CLLocationCoordinate2DMake(stop.lat, stop.lng);
        [annotations addObject:annotation];
        stopKeyTable[stop.station_no] = annotation;
    }
    
    NSLog(@"annotations: %lu", annotations.count);
    
    return annotations;
}

@end
