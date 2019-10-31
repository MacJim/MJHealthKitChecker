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

@end

NS_ASSUME_NONNULL_END
