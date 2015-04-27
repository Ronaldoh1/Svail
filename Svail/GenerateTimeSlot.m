//
//  GenerateTimeSlot.m
//  Svail
//
//  Created by Ronald Hernandez on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "GenerateTimeSlot.h"

@implementation GenerateTimeSlot

-(NSArray *)generateTimesArrayInNSNumbers{

    self.timesArray = [NSMutableArray new];


    //add the times (NSnumbers) to times array for use in cellForRowAtIndexPath

    for (int i = 0; i<48; i++){


        [self.timesArray addObject:[self numberWithHour:floor((float)i/2)  minute:i%2 * 30]];
        
        
    }
    NSArray *someArray = self.timesArray.copy;

    return someArray;
    
    
}
//helper method to convert hours and minutes into an nsnumber;

- (NSNumber *) numberWithHour: (NSUInteger)hour minute:(NSUInteger)minute{

    return @(hour*60*60 + minute*60);
}



@end
