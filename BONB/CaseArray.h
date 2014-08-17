//
//  BNBCaseArray.h
//  BONB
//
//  Created by Jake or Katie Wimberley on 8/15/14.
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Case.h"
#import "options.h"

@interface BNBCaseArray : NSObject

@property NSMutableArray *caseObjects;
@property NSMutableSet *assignedValues;
@property NSMutableArray *valuesOpened;
@property BNBCase *ownCase;
@property BOOL offerTaken;
@property NSNumber *maximumOffered;

- (id) init;
- (NSArray*) getRemainingValues;
- (NSArray*) getRemainingCaseNumbers;
- (void) pickCaseToHold;
- (NSNumber*) pickCaseToOpen;
- (void) printValueBoard;
- (void) printNumberBoard;
- (NSNumber*) calculateOfferValue;
- (NSNumber*) makeOffer;
- (void) handleTheOffer;
- (void) dump;

@end
