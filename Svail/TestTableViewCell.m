//
//  TestTableViewCell.m
//  Svail
//
//  Created by zhenduo zhu on 6/28/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TestTableViewCell

- (void)setupContent {
    // Initialization code
    self.label.text = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
