//
//  Case.h
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNBCase : NSObject <NSCopying>

typedef enum {
    OPENED,
    UNOPENED,
    HELD
} typeStatus;

@property NSNumber* number;
@property NSNumber* value;
@property typeStatus playStatus;

- (id) initWithNumber:(int)caseNumber value:(NSNumber*)caseValue status:(typeStatus)playStatus;
- (id) init;
- (BOOL) chooseAndReturnYesIfNumberMatches:(NSNumber*)choice;
- (NSNumber *) openAndReturnValueIfNumberMatches:(NSNumber*)choice;
- (NSNumber *) open;
- (NSNumber *) dumpValueIntoNSNumberIfNotOpened;
- (NSString *) dumpContentsIntoNSString;
- (void) swapValuesWith:(BNBCase *)anotherCase;
- (id) copyWithZone:(NSZone *)zone;

@end
