//
//  HealthKitManager.m
//  MJHealthKitChecker
//
//  Created by Yilin Shi on 2019-10-31.
//  Copyright © 2019 Creative Sub. All rights reserved.
//

#import "HealthKitManager.h"


@implementation HealthKitManager {
    BOOL _isHealthKitAvailable;
    BOOL _hasHealthKitPermission;
    
    /// A single health store object per app.
    HKHealthStore* _healthStore;
}


#pragma mark - Singleton stuff
+ (HealthKitManager*)sharedManager {
    static HealthKitManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HealthKitManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        if ([HKHealthStore isHealthDataAvailable]) {
            _isHealthKitAvailable = YES;
            _healthStore = [[HKHealthStore alloc] init];
            
            // Request Permission to Read and Share Data.
            NSSet* allDataTypes = [NSSet setWithObjects:
                                   [HKObjectType workoutType],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                   nil];
            [_healthStore requestAuthorizationToShareTypes:allDataTypes readTypes:allDataTypes completion:^(BOOL success, NSError *error){
                if (success) {
                    self->_hasHealthKitPermission = YES;
                } else {
                    self->_hasHealthKitPermission = NO;
                }
            }];
        } else {
            _isHealthKitAvailable = NO;
            _hasHealthKitPermission = NO;
        }
    }
    
    return self;
}


#pragma mark - Is health data available
- (BOOL)isHealthDataAvailable {
    return (_isHealthKitAvailable && _hasHealthKitPermission);
}

@end
