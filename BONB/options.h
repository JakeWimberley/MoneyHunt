//
//  options.h
//  BONB
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#ifndef BONB_options_h
#define BONB_options_h

static NSUInteger numberOfCaseValues = 26; // 26 on TV
static int caseValues[] = {1,2,5,10,25,50,75,100,200,300,400,500,750,1000,5000,10000,25000,50000,75000,100000,200000,300000,400000,500000,750000,1000000};
static int seriesInRound1 = 6; // 6 on TV

// When calcluating an offer, remaining cases are compared to following constants to determine
// their weighting in the offer. A case 'biggestMediumCase < case < smallestGiantCase' bears
// a weight of 1.
const static int biggestPicoCase = 25;         //4x
const static int biggestNanoCase = 300;        //3x
const static int biggestMicroCase = 5000;      //2x
const static int smallestMegaCase = 500000;    //1.5x

const static int worrySmall = 1000;
const static int worryLarge = 75000;

static NSString *dealerName = @"Big Dealer";

#endif
