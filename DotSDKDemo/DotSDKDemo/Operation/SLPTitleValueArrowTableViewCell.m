//
//  SLPTitleValueArrowTableViewCell.m
//  Sleepace
//
//  Created by Shawley on 6/25/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPTitleValueArrowTableViewCell.h"

@interface SLPTitleValueArrowTableViewCell ()

@end


@implementation SLPTitleValueArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineDown.backgroundColor = [UIColor whiteColor];
    self.lineDown.hidden = NO;
    self.titleLabel.textColor=[FontColor C3];
    self.titleLabel.font=[FontColor T3];
    self.detailInfoLabel.textColor=[FontColor C3];
    self.detailInfoLabel.font=[FontColor T4];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SLPTitleValueArrowTableViewCell";
    SLPTitleValueArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


@end
