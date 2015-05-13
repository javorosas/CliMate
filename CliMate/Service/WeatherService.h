//
//  WeatherService.h
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface WeatherService : NSObject

+ (instancetype)sharedInstance;

- (void)updateWeather:(Weather *)weather withCompletion:(void (^)(NSError *error))handler;
- (void)getForecastWithCompletion:(void(^)(NSError *error, NSArray *forecast))handler;

@end
