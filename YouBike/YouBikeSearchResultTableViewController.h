//
//  YouBikeSearchResultTableViewController.h
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import <UIKit/UIKit.h>
#import "YouBikeMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YouBikeSearchResultTableViewController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) YouBikeMapViewController *mapViewController;

@property (nonatomic, strong) NSArray<YouBikeStop *> *filteredData;


@end

NS_ASSUME_NONNULL_END
