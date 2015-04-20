//
//  Image.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Image.h"
#import <Parse/PFObject+Subclass.h>

@implementation Image

@dynamic service;
@dynamic imageFile;

+(void)load{
    [self registerSubclass];

}
+ (NSString *)parseClassName{
    return @"Image";
}
@end
