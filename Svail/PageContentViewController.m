//
//  PageContentViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 5/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.label1.text = self.textForLabel1;
    self.label2.text = self.textForLabel2;
    self.label1.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    self.label2.textColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
    self.imageForScreen.image = [UIImage imageNamed:self.imageFileName];

    

}




@end
