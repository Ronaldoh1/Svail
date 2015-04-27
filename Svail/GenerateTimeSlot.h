//
//  GenerateTimeSlot.h
//  Svail
//
//  Created by Ronald Hernandez on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenerateTimeSlot : NSObject
@property NSMutableArray *timesArray;


-(NSArray *)generateTimesArrayInNSNumbers;
-(NSNumber *)numberWithHour:(NSUInteger)hour minute:(NSUInteger)minute;


@end
