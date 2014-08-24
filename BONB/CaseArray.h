//
//  BNBCaseArray.h
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Case.h"
#import "BNBOptions.h"

@interface BNBCaseArray : NSObject

@property BNBOptions* optionsInUse;
@property NSMutableArray *caseObjects;
@property NSMutableSet *assignedValues;
@property NSMutableArray *valuesOpened;
@property BNBCase *ownCase;
@property BOOL offerTaken;
@property NSNumber *valueOfOfferTaken;
@property NSNumber *maximumOffered;

- (id) initWithOptions:(BNBOptions*)optionObject;
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
