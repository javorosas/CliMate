//
//  Weather.h
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, nonatomic) NSNumber *temp;
@property (strong, nonatomic) NSNumber *pressure;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *clouds;
@property (strong, nonatomic) NSURL *icon;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSNumber *minTemp;
@property (strong, nonatomic) NSNumber *maxTemp;
@property (strong, nonatomic) NSDate *date;

@end
