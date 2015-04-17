//
//  EventLocationSetter.m
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "EventLocationDownloader.h"

@implementation EventLocationDownloader 

+(void)downloadEventLocation:(void (^)(NSArray *))complete
{
    NSArray *emptyArray = @[];
    PFQuery *newQuery=[Service query];
    [newQuery whereKey:@"startDate" notContainedIn:emptyArray];
    [newQuery findObjectsInBackgroundWithBlock:^(NSArray *services, NSError *error) {

        NSArray *eventsArray = services;

        complete (eventsArray);
    }];
}


@end
