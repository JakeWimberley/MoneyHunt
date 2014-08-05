//
//  Case.m
//  BONB
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "Case.h"

static NSMutableSet* assignedValues;
static int counter = 0;

@implementation BNBCase

- (id) initRandomly {
    self = [super init];
    if (self) {
        NSNumber* randomValue;
        if (counter >= numberOfCaseValues) return self; //TODO
        while (1) {
            randomValue = [NSNumber numberWithInt:caseValues[arc4random() % 26]];
            if ([assignedValues containsObject:randomValue]) continue;
            else {
                [assignedValues addObject:randomValue];
                break;
            }
        }
        self.value = [randomValue copy];
        self.number = [NSNumber numberWithInt:++counter]; // prefix ++ assigns starting with 1
        self.playStatus = UNOPENED;
    }
    return self;
}

- (id) init {
    return [self initRandomly];
}

+ (void) initialize {
    assignedValues = [[NSMutableSet alloc] init];
}

- (BOOL) chooseAndReturnYesIfNumberMatches:(NSNumber*)choice {
    if (self.number == choice) {
        self.playStatus = HELD;
        return YES;
    }
    else return NO;
}

- (NSNumber *) openAndReturnValueIfNumberMatches:(NSNumber*)choice {
    if (self.number == choice && self.playStatus == UNOPENED) {
        self.playStatus = OPENED;
        return self.value;
    }
    else return nil;
}

- (NSNumber *) open {
    self.playStatus = OPENED;
    return self.value;
}

- (NSNumber *) dumpValueIntoNSNumberIfNotOpened { // want to include the HELD case
    if (self.playStatus != OPENED) return [self.value copy];
    else return nil;
}

- (NSString *) dumpContentsIntoNSString {
    return [NSString stringWithFormat:@"#%d, %d", [self.number intValue], [self.value intValue]];
}

@end
