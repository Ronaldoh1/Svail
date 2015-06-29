//
//  ViewUtilities.m
//  Svail
//
//  Created by zhenduo zhu on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "CustomViewUtilities.h"

@implementation CustomViewUtilities



+(void)transformToCircleViewFromSquareView:(UIView *)squareImageView
{
    squareImageView.layer.cornerRadius = squareImageView.frame.size.height / 2;
    squareImageView.layer.masksToBounds = YES;
    squareImageView.layer.borderWidth = 2.0;
    squareImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    squareImageView.layer.shouldRasterize = true;
    squareImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

+(NSMutableAttributedString *)setupTextWithHeader:(NSString *)headerString content:(NSString *)contentString fontSize:(CGFloat)fontSize
{
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",headerString,contentString];
    NSRange rangeOfHeader = [text rangeOfString:headerString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, text.length)];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]} range:rangeOfHeader];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:rangeOfHeader];
    return attributedText;
}




@end
