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
    BOOL _hasHealthKitPermissions;
    
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
    
    _hasHealthKitPermissions = NO;
    
    if (self) {
        if ([HKHealthStore isHealthDataAvailable]) {
            _isHealthKitAvailable = YES;
            _healthStore = [[HKHealthStore alloc] init];
            
            // Request permission to read and share data.
            NSSet* allDataTypes = [NSSet setWithObjects:
                                   [HKObjectType workoutType],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                   nil];
            [_healthStore requestAuthorizationToShareTypes:allDataTypes readTypes:allDataTypes completion:^(BOOL success, NSError *error){
                if (success) {
                    self->_hasHealthKitPermissions = YES;
                } else {
                    self->_hasHealthKitPermissions = NO;
                }
            }];
        } else {
            _isHealthKitAvailable = NO;
        }
    }
    
    return self;
}


#pragma mark - Is health data available
- (BOOL)isHealthDataAvailable {
    return (_isHealthKitAvailable && _hasHealthKitPermissions);
}


#pragma mark - Write data to the Health app
- (void)addSteps:(NSInteger)stepsCount startDate:(NSDate*)startDate endDate:(NSDate*)endDate withCompletion:(nullable void (^)(NSError* error))completion {
//    HKAuthorizationStatus* authorizationStatus = _healthStore authorizationStatusForType:HKObjectType quantityTypeForIdentifier:hkquantity
    
    // Quantity type: steps.
    HKQuantityType* stepsQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Count unit.
    HKUnit* unit = [HKUnit countUnit];
    
    // Quantity object.
    HKQuantity* quantity = [HKQuantity quantityWithUnit:unit doubleValue:stepsCount];
    
    HKQuantitySample* sample = [HKQuantitySample quantitySampleWithType:stepsQuantityType quantity:quantity startDate:startDate endDate:endDate];
    
    [_healthStore saveObject:sample withCompletion:^(BOOL success, NSError* _Nullable error) {
        NSLog(@"Step data addition result: %d", success);
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    }];
}

- (void)addStepsWithApproximateWalkDistance:(NSInteger)stepsCount startDate:(NSDate*)startDate endDate:(NSDate*)endDate withCompletion:(nullable void (^)(NSError* error))completion {
    // 1. Steps.
    HKQuantityType* stepsQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKUnit* stepsUnit = [HKUnit countUnit];
    HKQuantity* stepsQuantity = [HKQuantity quantityWithUnit:stepsUnit doubleValue:stepsCount];
    HKQuantitySample* stepsSample = [HKQuantitySample quantitySampleWithType:stepsQuantityType quantity:stepsQuantity startDate:startDate endDate:endDate];
    
    // 2. Distance walked.
    // Each step is 0.762 meters long for an average man.
    // In this case I will choose a random number between 0.7 and 0.85.
    double distanceMultiplier = (double)((arc4random() % 15) + 70) / 100;
    NSLog(@"Random distance multiplier used: %lf", distanceMultiplier);
    double distanceWalked = distanceMultiplier * stepsCount;
    
    HKQuantityType* distanceType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKUnit* distanceUnit = [HKUnit meterUnit];
    HKQuantity* distanceQuantity = [HKQuantity quantityWithUnit:distanceUnit doubleValue:distanceWalked];
    HKQuantitySample* distanceSample = [HKQuantitySample quantitySampleWithType:distanceType quantity:distanceQuantity startDate:startDate endDate:endDate];
    
    // 3. Store in health store.
    [_healthStore saveObjects:@[stepsSample, distanceSample] withCompletion:^(BOOL success, NSError* _Nullable error) {
        NSLog(@"Step and distance data addition result: %d", success);
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    }];
}



@end
