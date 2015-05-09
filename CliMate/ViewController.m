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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeatherService *service = [WeatherService sharedInstance];
    NSString *units = self.unitsSegment.selectedSegmentIndex == 0 ? @"metric" : @"imperial";
    Weather *weather = [Weather initWithLongitude:@(-110.97) latitude:@(29.07) units:units];
    [service updateWeather:weather withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°%@", [weather.temp integerValue], weather.unit_symbol];
            self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@ %%", weather.humidity];
            self.cloudsLabel.text = [NSString stringWithFormat:@"Clouds: %@", weather.clouds];
            self.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %@ hpa", weather.pressure];
            self.statusLabel.text = weather.status;
            self.iconImage.image = [UIImage imageWithData:weather.icon];
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
@end
