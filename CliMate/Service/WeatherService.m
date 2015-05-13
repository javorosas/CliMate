//
//  WeatherService.m
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "WeatherService.h"
#import "Weather.h"
#import <AFNetworking/AFNetworking.h>

@implementation WeatherService

static NSString *iconUrl = @"http://openweathermap.org/img/w/";

+ (instancetype)sharedInstance {
    static WeatherService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WeatherService alloc] init];
    });
    return sharedInstance;
}

-(void)updateWeather:(Weather *)weather withCompletion:(void (^)(NSError *))handler {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *url = @"http://api.openweathermap.org/data/2.5/weather";
    NSDictionary *params = @{ @"lat": [defaults objectForKey:@"latitude"],
                      @"lon": [defaults objectForKey:@"longitude"],
                      @"units": [defaults objectForKey:@"units"] };
    
    NSLog(@"%@", params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             weather.temp = responseObject[@"main"][@"temp"];
             weather.humidity = responseObject[@"main"][@"humidity"];
             weather.clouds = responseObject[@"clouds"][@"all"];
             weather.pressure = responseObject[@"main"][@"pressure"];
             weather.icon = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png", iconUrl, responseObject[@"weather"][0][@"icon"]]];
             weather.status = responseObject[@"weather"][0][@"description"];
             if (handler) {
                 handler(nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             if (handler) {
                 handler(error);
             }
         }];
}

- (void) getForecastWithCompletion:(void (^)(NSError *, NSArray *))handler {
    NSString *url = @"http://api.openweathermap.org/data/2.5/forecast/daily";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"lat": [defaults objectForKey:@"latitude"],
                             @"lon": [defaults objectForKey:@"longitude"],
                             @"cnt": @(10),
                             @"units": [defaults objectForKey:@"units"] };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableArray *forecast = [NSMutableArray array];
             for (NSDictionary *element in responseObject[@"list"]) {
                 Weather *weather = [[Weather alloc] init];
                 weather.icon = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png", iconUrl, element[@"weather"][0][@"icon"]]];
                 weather.status = element[@"weather"][0][@"description"];
                 weather.date = [NSDate dateWithTimeIntervalSince1970: [element[@"dt"] floatValue]];
                 weather.minTemp = element[@"temp"][@"min"];
                 weather.maxTemp = element[@"temp"][@"max"];
                 
                 [forecast addObject:weather];
             }
             if (handler) {
                 handler(nil, [forecast copy]);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
             if (handler) {
                 handler(error, nil);
             }
         }];
}

@end
