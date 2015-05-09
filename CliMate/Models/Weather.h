//
//  Weather.h
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSNumber *lat;
@property NSNumber *lon;
@property NSNumber *temp;
@property NSString *units;
@property NSNumber *pressure;
@property NSNumber *humidity;
@property NSNumber *clouds;
@property NSURL *icon;
@property NSString *status;
@property NSString *unit_symbol;

+ (instancetype)initWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude units:(NSString *)units;

@end
