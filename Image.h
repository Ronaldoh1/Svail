//
//  Image.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "Service.h"

@interface Image : PFObject<PFSubclassing>
@property PFFile *imageFile;
@property Service *service;

+ (NSString *)parseClassName;

@end
