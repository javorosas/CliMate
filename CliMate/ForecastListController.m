//
//  TableViewController.m
//  CliMate
//
//  Created by Javier Rosas on 5/11/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "ForecastListController.h"
#import "WeatherService.h"
#import "ForecastCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ForecastListController ()

@property NSArray *forecast;

@end

@implementation ForecastListController

static NSString *CellIdentifier = @"ForecastCellIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Forecast";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    WeatherService *service = [WeatherService sharedInstance];
    [service getForecastWithCompletion:^(NSError *error, NSArray *forecast) {
        if (error) {
            // Show error
        } else {
            self.forecast = forecast;
            [self.tableView reloadData];
        }
    }];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.forecast.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Weather *weather = self.forecast[indexPath.row];
    NSString *unitSymbol = [[defaults objectForKey:@"units"] isEqualToString:@"metric"] ? @"C" : @"F";
    cell.status.text = weather.status;
    cell.minTemp.text = [NSString stringWithFormat:@"Min: %li°%@", [weather.minTemp integerValue], unitSymbol];
    cell.maxTemp.text = [NSString stringWithFormat:@"Max: %li°%@", [weather.maxTemp integerValue], unitSymbol];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM d"];
    cell.date.text = [dateFormatter stringFromDate:weather.date];
    
    [cell.icon sd_setImageWithURL:weather.icon];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
