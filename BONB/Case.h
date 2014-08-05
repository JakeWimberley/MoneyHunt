//
//  Case.h
//  BONB
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "options.h"

@interface BNBCase : NSObject

typedef enum {
    OPENED,
    UNOPENED,
    HELD
} typeStatus;

@property NSNumber* number;
@property NSNumber* value;
@property typeStatus playStatus;

+ (void) initialize;
- (id) initRandomly;
- (id) init;
- (BOOL) chooseAndReturnYesIfNumberMatches:(NSNumber*)choice;
- (NSNumber *) openAndReturnValueIfNumberMatches:(NSNumber*)choice;
- (NSNumber *) open;
- (NSNumber *) dumpValueIntoNSNumberIfNotOpened;
- (NSString *) dumpContentsIntoNSString;

@end
