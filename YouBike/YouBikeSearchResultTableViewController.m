//
//  YouBikeSearchResultTableViewController.m
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import "YouBikeSearchResultTableViewController.h"
#import "YouBikeAnnotation.h"

@interface YouBikeSearchResultTableViewController ()

@end

@implementation YouBikeSearchResultTableViewController

@synthesize mapViewController;
@synthesize filteredData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    YouBikeStop *stop = filteredData[indexPath.row];
    cell.textLabel.text = stop.name_tw;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YouBikeStop *stop = filteredData[indexPath.row];
    id annotation = mapViewController.stopKeyTable[stop.station_no];
    NSLog(@"%@", annotation);
    if (annotation)
        [self dismissViewControllerAnimated:YES completion:^{
            [self.mapViewController.mapView showAnnotations:@[annotation] animated:YES];
        }];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar text];
    NSMutableArray *filteredData = [NSMutableArray array];
    
    for (YouBikeStop *stop in mapViewController.youbikeData) {
        if ([stop.name_tw containsString:searchText]) {
            [filteredData addObject: stop];
        }
    }
    
    self.filteredData = filteredData;
    [self.tableView reloadData];
}

@end
