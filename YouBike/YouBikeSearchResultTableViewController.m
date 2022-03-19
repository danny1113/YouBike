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

- (void)dealloc {
    NSLog(@"YouBikeSearchResultTableViewController deinit");
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
    configureCell(cell, stop);
    
    return cell;
}

void configureCell(UITableViewCell *cell, YouBikeStop *stop) {
    UIImage *image;
    UIColor *imageColor;
    
    if (stop.available_spaces == 0 || stop.empty_spaces == 0) {
        image = [UIImage systemImageNamed:@"xmark.square.fill"];
        imageColor = [UIColor systemRedColor];
    } else if (stop.available_spaces < 3 || stop.empty_spaces < 3) {
        image = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
        imageColor = [UIColor systemOrangeColor];
    } else {
        image = [UIImage systemImageNamed:@"checkmark.circle"];
        imageColor = [UIColor systemGreenColor];
    }
    
    cell.textLabel.text = stop.name_tw;
    cell.imageView.image = image;
    cell.imageView.tintColor = imageColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YouBikeStop *stop = filteredData[indexPath.row];
    id annotation = mapViewController.stopKeyTable[stop.station_no];
    NSLog(@"%@", annotation);
    if (annotation && mapViewController.mapView)
        [self dismissViewControllerAnimated:YES completion:^{
            [self.mapViewController.mapView selectAnnotation:annotation animated:NO];
            [self.mapViewController.mapView showAnnotations:@[annotation] animated:NO];
        }];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *filteredData = [NSMutableArray array];
        
        for (YouBikeStop *stop in self.mapViewController.youbikeData)
            if ([stop.name_tw localizedCaseInsensitiveContainsString:searchText] ||
                [stop.name_en localizedCaseInsensitiveContainsString:searchText])
                [filteredData addObject:stop];
        
        self.filteredData = filteredData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

@end
