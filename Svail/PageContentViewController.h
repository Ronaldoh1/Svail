//
//  PageContentViewController.h
//  Svail
//
//  Created by Ronald Hernandez on 5/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property NSString *textForLabel1;
@property NSString *textForLabel2;
@property NSString *imageFileName;

@property NSArray *arrayPageImages;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *imageForScreen;

@property  NSUInteger pageIndex;

@end
