//
//  YouBikeStopDetailView.m
//  YouBike
//
//  Created by 龐達業 on 2022/3/15.
//

#import "YouBikeStopDetailView.h"

@implementation YouBikeStopDetailView

@synthesize stop;


- (instancetype)initWithStop:(YouBikeStop *)stop {
    self = [self init];
    
    if (self) {
        self.stop = stop;
        [self configureView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self configureView];
    }
    
    return self;
}

- (void)configureView {
    NSLog(@"configureView");
    YouBikeStopDetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"YouBikeStopDetailView" owner:self options:nil] firstObject];
    
    
    view.layer.cornerRadius = 10;
    view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.stopNameLabel.text = stop.name_tw;
    self.bikeDetailInfoLabel.text = [NSString stringWithFormat:@"%hd.0站", stop.type];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [view.topAnchor constraintEqualToAnchor:self.topAnchor],
        [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
}


@end
