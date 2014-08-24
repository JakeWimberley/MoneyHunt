//
//  BNBOptions.h
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNBDealer.h"

@interface BNBOptions : NSObject

// Locale
@property NSNumberFormatter *asCurrency;

// Length of game
@property NSArray* allCaseValues;
@property int numberOfSeriesInRound1;

// Inputs to offer calculation scheme
@property int biggestPicoCase;
@property int biggestNanoCase;
@property int biggestMicroCase;
@property int smallestMegaCase;
@property int worrySmall;
@property int worryLarge;

// User interactions
@property NSArray *dealers;

- (id) init;
- (id) initNormalGame;
- (BNBDealer*) getRandomDealer;
- (const char*) formatNumberAsCurrency:(NSNumber*)number;

@end
