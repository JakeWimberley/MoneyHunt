//
//  main.h
//  BONB
//
//  Created by Jake or Katie Wimberley on 7/20/14.
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#ifndef BONB_main_h
#define BONB_main_h

#import <Foundation/Foundation.h>
#import "Case.h"
#import "options.h"

const BOOL debugging = NO;

NSArray* getRemainingValues(NSMutableArray*);
NSArray* getRemainingCaseNumbers(NSMutableArray*);
void printValueBoard(NSMutableArray*);
void printNumberBoard(NSMutableArray*);
BNBCase* pickCaseToHold(NSMutableArray*);
NSNumber* pickCaseToOpen(NSMutableArray *cases, NSMutableArray *valuesOpened);
NSNumber* calculateOfferValue(NSMutableArray *cases, NSMutableArray *valuesOpened);
NSNumber* makeOffer(NSMutableArray *cases, NSMutableArray *valuesOpened);
void handleTheOffer(BNBCase* ownCase, NSMutableArray* cases, NSMutableArray* valuesOpened);

#endif
