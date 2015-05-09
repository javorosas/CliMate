//
//  ViewController.m
//  CliMate
//
//  Created by Javier Rosas on 5/7/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "ViewController.h"
#import "Weather.h"
#import "WeatherService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSegment;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;



@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

- (void)update;
- (IBAction)refresh:(id)sender;
- (IBAction)unitsSelected:(id)sender;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeatherService *service = [WeatherService sharedInstance];
    NSString *units = self.unitsSegment.selectedSegmentIndex == 0 ? @"metric" : @"imperial";
    Weather *weather = [Weather initWithLongitude:self.longitude latitude:self.latitude units:units];
    [service updateWeather:weather withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°%@", [weather.temp integerValue], weather.unit_symbol];
            self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@ %%", weather.humidity];
            self.cloudsLabel.text = [NSString stringWithFormat:@"Clouds: %@", weather.clouds];
            self.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %@ hpa", weather.pressure];
            self.statusLabel.text = weather.status;
            [self.iconImage sd_setImageWithURL:weather.icon];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)refresh:(id)sender {
    [self update];
}

- (IBAction)unitsSelected:(id)sender {
    [self update];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations: %@", locations[0]);
    CLLocation *currentLocation = locations[0];
    
    if (currentLocation != nil) {
        self.latitude = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
        self.longitude = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
        [self.locationManager stopUpdatingLocation];
        [self update];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"WHAAT?");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"locationManager failed%@", error);
        self.latitude = @(19.43);
        self.longitude = @(-99.13);
        [self update];
    }
}
@end
