//
//  Verification.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
@interface Verification : PFObject<PFSubclassing>

@property NSArray *verifiers;
@property NSNumber *safetyLevel;
@property (nonatomic) NSNumber *fbLevel;
@property (nonatomic) NSNumber *ttLevel;
@property (nonatomic) NSNumber *lkLevel;



@end
