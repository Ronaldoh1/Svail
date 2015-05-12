//
//  ViewUtilities.h
//  Svail
//
//  Created by zhenduo zhu on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomViewUtilities : NSObject


+(void)transformToCircleViewFromSquareView:(UIView *)squareImageView;
+(NSMutableAttributedString *)setupTextWithHeader:(NSString *)headerString content:(NSString *)contentString fontSize:(CGFloat)fontSize;

@end
