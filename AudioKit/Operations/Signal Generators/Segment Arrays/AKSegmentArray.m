//
//  AKSegmentArray.m
//  AudioKit
//
//  Created by Aurelius Prochazka on 1/4/15.
//  Copyright (c) 2015 AudioKit. All rights reserved.
//

#import "AKSegmentArray.h"

@implementation AKSegmentArray
{
    AKConstant *value1;
    NSMutableArray *segments;
    NSArray *releaseSegment;
}

- (instancetype)initWithInitialValue:(AKConstant *)initialValue
                         targetValue:(AKConstant *)targetValue
                       afterDuration:(AKConstant *)duration
                           concavity:(AKConstant *)concavity

{
    self = [super initWithString:[self operationName]];
    if (self) {
        value1      = initialValue;
        segments = [[NSMutableArray alloc] init];
        releaseSegment = [NSArray array];
        [self addValue:targetValue afterDuration:duration concavity:concavity];
    }
    
    return self;
}

- (void)addValue:(AKConstant *)value
   afterDuration:(AKConstant *)duration
       concavity:(AKConstant *)concavity
{
    [segments addObject:duration];
    [segments addObject:concavity];
    [segments addObject:value];
}

- (instancetype)initWithInitialValue:(AKConstant *)initialValue
                         targetValue:(AKConstant *)targetValue
                       afterDuration:(AKConstant *)duration
{
    return [self initWithInitialValue:initialValue
                          targetValue:targetValue
                        afterDuration:duration
                            concavity:akp(1)];
}

- (void)addValue:(AKConstant *)value afterDuration:(AKConstant *)duration
{
    [self addValue:value afterDuration:duration concavity:akp(1)];
}

- (void)releaseToValue:(AKConstant *)value
         afterDuration:(AKConstant *)duration
             concavity:(AKConstant *)concavity
{
    releaseSegment = [NSArray arrayWithObjects:duration, concavity, value, nil];
}

- (NSString *)stringForCSD {
    NSString *opcode = @"transeg";
    if ([releaseSegment count] > 0) {
        opcode = @"transegr";
        [segments addObject:[releaseSegment objectAtIndex:0]];
        [segments addObject:[releaseSegment objectAtIndex:1]];
        [segments addObject:[releaseSegment objectAtIndex:2]];
    }
    return [NSString stringWithFormat:
            @"%@ %@ %@, %@",
            self,
            opcode,
            value1,
            [segments componentsJoinedByString:@", "]];
}

@end