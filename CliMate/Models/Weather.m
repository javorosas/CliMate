//
//  Weather.m
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (instancetype)initWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude units:(NSString *)units {
    return [[Weather alloc] initWithLongitude:longitude latitude:latitude units:units];
}

- (instancetype)initWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude units:(NSString *)units {
    self = [super init];
    if (self) {
        self.lat = latitude;
        self.lon = longitude;
        self.units = units;
    }
    return self;
}

@end
