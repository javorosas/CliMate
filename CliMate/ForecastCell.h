//
//  ForecastCell.h
//  CliMate
//
//  Created by Javier Rosas on 5/12/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastCell : UITableViewCell

@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *status;
@property (weak, nonatomic) UILabel *minTemp;
@property (weak, nonatomic) UILabel *maxTemp;
@property (weak, nonatomic) UILabel *date;

@end
