//
//  BNBOptions.m
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "BNBOptions.h"

@implementation BNBOptions

- (id) init {
    return [self initNormalGame];
}

- (id) initNormalGame {
    self = [super init];
    if (self) {
        self.asCurrency = [[NSNumberFormatter alloc] init];
        [self.asCurrency setNumberStyle:NSNumberFormatterCurrencyStyle];
        [self.asCurrency setMaximumFractionDigits:0];
        self.allCaseValues = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:5], [NSNumber numberWithInt:10], [NSNumber numberWithInt:25],
                              [NSNumber numberWithInt:50], [NSNumber numberWithInt:75], [NSNumber numberWithInt:100],
                              [NSNumber numberWithInt:200], [NSNumber numberWithInt:300], [NSNumber numberWithInt:400],
                              [NSNumber numberWithInt:500], [NSNumber numberWithInt:750], [NSNumber numberWithInt:1000],
                              [NSNumber numberWithInt:5000], [NSNumber numberWithInt:10000], [NSNumber numberWithInt:25000],
                              [NSNumber numberWithInt:50000], [NSNumber numberWithInt:75000], [NSNumber numberWithInt:100000],
                              [NSNumber numberWithInt:200000], [NSNumber numberWithInt:300000], [NSNumber numberWithInt:400000],
                              [NSNumber numberWithInt:500000], [NSNumber numberWithInt:750000], [NSNumber numberWithInt:1000000], nil];
        self.numberOfSeriesInRound1 = 6;
        self.biggestPicoCase = 25;
        self.biggestNanoCase = 300;
        self.biggestMicroCase = 5000;
        self.smallestMegaCase = 500000;
        self.worrySmall = 1000;
        self.worryLarge = 75000;
        self.dealers = [NSArray arrayWithObjects:
                        [[BNBDealer alloc] initWithName:@"Larry Ellison"
                                                   talk:[NSArray arrayWithObjects:
                                                         @"I'd like to SAIL AWAY with your case right now!",
                                                         @"My database tells me this is a good deal.",
                                                         nil]],
                        [[BNBDealer alloc] initWithName:@"Jeff Bezos"
                                                   talk:[NSArray arrayWithObject:@"If you make this deal, a drone will be over to pick up the case in 10 minutes."]],
                        [[BNBDealer alloc] initWithName:@"Bill Gates"
                                                   talk:[NSArray arrayWithObjects:
                                                         @"I'll donate 10% of the profits on this deal to the Foundation.",
                                                         @"640k of RAM ought to be enough for anybody, but you can never make enough money.",
                                                         nil]],
                        [[BNBDealer alloc] initWithName:@"Google"
                                                   talk:[NSArray arrayWithObjects:
                                                         @"Don't be evil. Make us a good deal.",
                                                         @"We're feeling lucky!",
                                                         @"Pleeeeeeeease?",
                                                         nil]],
                        nil];
    }
    return self;
}

- (BNBDealer*) getRandomDealer {
    return self.dealers[arc4random() % [self.dealers count]];
}

- (const char*) formatNumberAsCurrency:(NSNumber*)number {
    return [[[self asCurrency] stringFromNumber:number] UTF8String];
}

@end
