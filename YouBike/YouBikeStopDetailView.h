//
//  YouBikeStopDetailView.h
//  YouBike
//
//  Created by 龐達業 on 2022/3/15.
//

#import <UIKit/UIKit.h>
#import "YouBikeStop.h"

NS_ASSUME_NONNULL_BEGIN

@interface YouBikeStopDetailView : UIView

@property (nonatomic) YouBikeStop *stop;

@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikeDetailInfoLabel;

- (instancetype)initWithStop:(YouBikeStop *)stop;

@end

NS_ASSUME_NONNULL_END
