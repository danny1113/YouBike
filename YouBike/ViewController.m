//
//  ViewController.m
//  YouBike
//
//  Created by 龐達業 on 2022/3/13.
//

#import "ViewController.h"
#import "YouBikeMapViewController.h"

@interface ViewController ()

- (IBAction)show:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)show:(id)sender {
    YouBikeMapViewController *mapViewController = [[YouBikeMapViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
