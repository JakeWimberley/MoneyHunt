//
//  Case.m
//  BONB
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "Case.h"

@implementation BNBCase

- (id) initWithNumber:(int)caseNumber value:(NSNumber *)caseValue status:(typeStatus)itsStatus {
    self = [super init];
    if (self) {
        self.number = [NSNumber numberWithInteger:caseNumber];
        self.value = caseValue;
        self.playStatus = itsStatus;
    }
    return self;
}
- (id) init {
    self = [super init];
    if (self) {
        self.number = 0;
        self.value = 0;
        self.playStatus = UNOPENED;
    }
    return self;
}

- (BOOL) chooseAndReturnYesIfNumberMatches:(NSNumber*)choice {
    if ([self.number isEqualToNumber:choice]) {
        self.playStatus = HELD;
        return YES;
    }
    else return NO;
}

- (NSNumber *) openAndReturnValueIfNumberMatches:(NSNumber*)choice {
    if ([self.number isEqualToNumber:choice] && self.playStatus == UNOPENED) {
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

- (id) copyWithZone:(NSZone *)zone {
    BNBCase *caseCopy = [[BNBCase alloc] initWithNumber:[self.number intValue] value:self.value status:self.playStatus];
    return caseCopy;
}

@end
