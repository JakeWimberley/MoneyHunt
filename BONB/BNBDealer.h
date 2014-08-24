//
//  BNBDealer.h
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNBDealer : NSObject

@property NSString* name;
@property NSArray* offerTalk;

- (id) init;
- (id) initWithName:(NSString*)name talk:(NSArray*)talk;
- (id) getRandomTalk;

@end
