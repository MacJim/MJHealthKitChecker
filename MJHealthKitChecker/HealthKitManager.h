//
//  HealthKitManager.h
//  MJHealthKitChecker
//
//  Created by Yilin Shi on 2019-10-31.
//  Copyright © 2019 Creative Sub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HealthKitManager : NSObject

#pragma mark - Singleton stuff
+ (HealthKitManager*)sharedManager;


#pragma mark - Is health data available
@property(readonly) BOOL isHealthDataAvailable;


#pragma mark - Write data to the Health app
/// Adds steps only.
- (void)addSteps:(NSInteger)stepsCount startDate:(NSDate*)startDate endDate:(NSDate*)endDate withCompletion:(nullable void (^)(NSError* error))completion;
/// Calculates walk distance based on steps count.
- (void)addStepsWithApproximateWalkDistance:(NSInteger)stepsCount startDate:(NSDate*)startDate endDate:(NSDate*)endDate withCompletion:(nullable void (^)(NSError* error))completion;

@end

NS_ASSUME_NONNULL_END
