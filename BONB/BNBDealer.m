//
//  BNBDealer.m
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "BNBDealer.h"

@implementation BNBDealer

- (id) init {
    self = [super init];
    if (self) {
        self.name = [[NSString alloc] init];
        self.offerTalk = [[NSArray alloc] init];
    }
    return self;
}

- (id) initWithName:(NSString *)name talk:(NSArray *)talk {
    self = [super init];
    if (self) {
        self.name = [name copy];
        self.offerTalk = [talk copy];
    }
    return self;
}

- (id) getRandomTalk {
    return self.offerTalk[arc4random() % [self.offerTalk count]];
}

@end
