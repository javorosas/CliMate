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

- (void)update;
- (IBAction)refresh:(id)sender;
- (IBAction)unitsSelected:(id)sender;

@end

@implementation ViewController

float const kDefaultLatitude = 19.43;
float const kDefaultLongitude = -99.13;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *units = [defaults objectForKey:@"units"];
    if (!units) {
        [defaults setObject:@"metric" forKey:@"units"];
        [defaults synchronize];
    }
    self.unitsSegment.selectedSegmentIndex = [units isEqualToString:@"metric"] ? 0 : 1;
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeatherService *service = [WeatherService sharedInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *units = [defaults objectForKey:@"units"];
    Weather *weather = [[Weather alloc] init];
    [service updateWeather:weather withCompletion:^(NSError *error) {
        if (error) {
            [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
        } else {
            NSString *unitSymbol = [units isEqualToString:@"metric"] ? @"C" : @"F";
            self.temperatureLabel.text = [NSString stringWithFormat:@"%li°%@", [weather.temp longValue], unitSymbol];
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
    NSString *units = self.unitsSegment.selectedSegmentIndex == 0 ? @"metric" : @"imperial";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:units forKey:@"units"];
    [defaults synchronize];
    [self update];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations: %@", locations[0]);
    CLLocation *currentLocation = locations[0];
    
    if (currentLocation != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(currentLocation.coordinate.latitude) forKey:@"latitude"];
        [defaults setObject:@(currentLocation.coordinate.longitude) forKey:@"longitude"];
        [defaults synchronize];
        [self.locationManager stopUpdatingLocation];
        [self update];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"locationManager failed%@", error);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(kDefaultLatitude) forKey:@"latitude"];
        [defaults setObject:@(kDefaultLongitude) forKey:@"longitude"];
        [defaults synchronize];
        [self update];
    }
}
@end
