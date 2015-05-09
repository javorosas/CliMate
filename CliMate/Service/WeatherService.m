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

+ (instancetype)sharedInstance {
    static WeatherService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WeatherService alloc] init];
    });
    return sharedInstance;
}

-(void)updateWeather:(Weather *)weather withCompletion:(void (^)(NSError *))handler {
    NSString *url = @"http://api.openweathermap.org/data/2.5/weather";
    NSString *iconUrl = @"http://openweathermap.org/img/w/";
    NSDictionary *params = @{ @"lat": [NSString stringWithFormat:@"%@", weather.lat],
                      @"lon": [NSString stringWithFormat:@"%@", weather.lon],
                      @"units": weather.units };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
             
             weather.temp = responseObject[@"main"][@"temp"];
             weather.humidity = responseObject[@"main"][@"humidity"];
             weather.clouds = responseObject[@"clouds"][@"all"];
             weather.pressure = responseObject[@"main"][@"pressure"];
             weather.unit_symbol = [weather.units isEqualToString:@"metric"] ? @"C" : @"F";
             weather.icon = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png", iconUrl, responseObject[@"weather"][0][@"icon"]]];
             weather.status = responseObject[@"weather"][0][@"description"];
             handler(nil);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             handler(error);
         }];
}

@end
