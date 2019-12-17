//
//  ViewController.m
//  MJHealthKitChecker
//
//  Created by Jim Macintosh Shi on 10/31/19.
//  Copyright © 2019 Creative Sub. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitManager.h"


@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View loading stuff
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HealthKitManager sharedManager];
}


#pragma mark IB stuff
- (IBAction)addStepsButtonPressed:(UIButton *)sender {
    NSInteger stepsCount = 10;
    NSDate* currentDate = [NSDate date];
    NSDate* testStartDate = [currentDate dateByAddingTimeInterval:-20];
    NSDate* testEndDate = currentDate;
//    [[HealthKitManager sharedManager] addSteps:stepsCount startDate:testStartDate endDate:testEndDate withCompletion:^(NSError* _Nullable error) {
//        if (error) {
//            NSLog(error.description);
//        }
//    }];
    [[HealthKitManager sharedManager] addStepsWithApproximateWalkDistance:stepsCount startDate:testStartDate endDate:testEndDate withCompletion:^(NSError* _Nullable error) {
        if (error) {
            NSLog(error.description);
        }
    }];
}

@end
