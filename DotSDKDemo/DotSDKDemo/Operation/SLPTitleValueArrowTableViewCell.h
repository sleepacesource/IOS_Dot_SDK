//
//  SLPTitleValueArrowTableViewCell.h
//  Sleepace
//
//  Created by Shawley on 6/25/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPTitleValueArrowTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *detailInfoLabel;
@property (nonatomic,weak) IBOutlet UIImageView *icon;
@property (nonatomic,weak) IBOutlet UIView *lineDown;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
