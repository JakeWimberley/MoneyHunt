//
//  BNBCaseArray.m
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "CaseArray.h"

@implementation BNBCaseArray

- (id) initWithOptions:(BNBOptions *)optionObject {
    if (! [optionObject isMemberOfClass:[BNBOptions self]]) return nil; // ?
    self = [super init];
    if (self) {
        self.optionsInUse = optionObject;
        self.caseObjects = [[NSMutableArray alloc] init];
        self.assignedValues = [[NSMutableSet alloc] init];
        self.valuesOpened = [[NSMutableArray alloc] init];
        self.ownCase = nil;
        self.offerTaken = NO;
        self.valueOfOfferTaken = nil;
        self.maximumOffered = [NSNumber numberWithInt:0];
        // Make the caseObjects array with values in the order specified by the optionObject
        for (int caseCounter = 0; caseCounter < [optionObject.allCaseValues count]; caseCounter++) {
            BNBCase* newCase = [[BNBCase alloc] initWithNumber:caseCounter+1
                                    value:optionObject.allCaseValues[caseCounter] status:UNOPENED];
            self.caseObjects[caseCounter] = [newCase copy];
        }
        // Randomize the case order with a Knuth-Fisher-Yates shuffle, as described wonderfully by Jeff Atwood
        // http://blog.codinghorror.com/the-danger-of-naivete/
        for (NSUInteger caseCounter = [optionObject.allCaseValues count] - 1; caseCounter > 0; caseCounter--) {
            int randomIndex = arc4random() % (caseCounter + 1);
            [self.caseObjects[caseCounter] swapValuesWith:self.caseObjects[randomIndex]];
        }
    }
    return self;
}

- (NSArray*) getRemainingValues {
    NSPredicate *isNotOpened = [NSPredicate predicateWithFormat:@"playStatus = %i", UNOPENED];
    NSArray *remainingCases = [self.caseObjects filteredArrayUsingPredicate:isNotOpened];
    NSSortDescriptor *sortByValue;
    sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    return [remainingCases sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]];
}

- (NSArray*) getRemainingCaseNumbers {
    NSPredicate *isNotOpened = [NSPredicate predicateWithFormat:@"playStatus = %i", UNOPENED];
    NSArray *remainingCases = [self.caseObjects filteredArrayUsingPredicate:isNotOpened];
    NSSortDescriptor *sortByNumber;
    sortByNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    return [remainingCases sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByNumber]];
}

- (void) printValueBoard {
    /* print remaining denominations in two columns like on TV
     thus, this loop steps through the first half of cases[] only
     note getRemainingValues is not used since spaces need to be printed in lieu of cases not in play */
    NSSortDescriptor *sortByValue;
    sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    NSArray *sortedCases = [self.caseObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]];
    NSUInteger numberOfDisplayRows = [[self.optionsInUse allCaseValues] count] / 2 + ([[self.optionsInUse allCaseValues] count] & 1);
	printf("\n+-------+-------+\n");
	for (NSUInteger j = 0; j < numberOfDisplayRows; j++) {
        NSNumber *thisValue;
        // left column
		thisValue = [sortedCases[j] dumpValueIntoNSNumberIfNotOpened];
        if (thisValue == nil) {
			printf("|       |");
		} else {
			printf("|%-7i|", [thisValue intValue]);
		}
        // right column
		NSUInteger k = j + numberOfDisplayRows;
        thisValue = [sortedCases[k] dumpValueIntoNSNumberIfNotOpened];
		if (thisValue == nil) {
			printf("       |\n");
		} else {
			printf("%7i|\n", [thisValue intValue]);
		}
	}
	printf("+-------+-------+\n");
}

- (void) printNumberBoard {
    NSArray* casesInPlay = [self getRemainingCaseNumbers];
    printf("\n");
    for (BNBCase* thisCase in casesInPlay) {
        printf("%i ", [[thisCase number] intValue]);
    }
    printf("\n\n");
}

- (void) pickCaseToHold {
    printf("Pick a case to hold for yourself: ");
	int x = 0;
	while (1) {
		scanf("%i", &x);
        for (BNBCase* thisCase in self.caseObjects) {
            if ([thisCase chooseAndReturnYesIfNumberMatches:[NSNumber numberWithInt:x]]) {
                self.ownCase = [thisCase copy];
                return;
            };
        }
        printf("No such case. Try again: ");
    }
}

- (NSNumber*) pickCaseToOpen {
    printf("Pick a case to open: ");
    int x = 0;
    NSNumber* returnValue = nil;
    while (1) {
		scanf("%i", &x);
        for (BNBCase* thisCase in self.caseObjects) {
            returnValue = [thisCase openAndReturnValueIfNumberMatches:[NSNumber numberWithInt:x]];
            if (returnValue != nil) {
                printf("That case was valued at...   %s\n", [self.optionsInUse formatNumberAsCurrency:returnValue]);
                [self.valuesOpened addObject:returnValue];
                return returnValue;
            }
        }
        printf("You can't pick that case. Try again: ");
        // TODO bug here... endless loop if bad input
    }
}

- (NSNumber*) calculateOfferValue {
    /* three components of offer:
     rounded weighted average of remaining cases,
     "worry factor" - a string of low choices by the contestant
     makes offer go higher,
     random value, m * 10**n,  where 1 <= m <= 9 and 1 <= n <= 3 */
	int accum = 0;
	double avg = 0.0;
    NSUInteger countValuesOpened = [self.valuesOpened count]; //TODO check value ==0
    // Weighted average
    NSArray* remainingValues = [self getRemainingValues];
    for (BNBCase *_case in remainingValues) {
        NSNumber *value = [_case value];
        double weight = 1;
        if ([value intValue] <= [self.optionsInUse biggestPicoCase]) weight = 4;
        else if ([value intValue] <= [self.optionsInUse biggestNanoCase]) weight = 3;
        else if ([value intValue] <= [self.optionsInUse biggestMicroCase]) weight = 2;
        if ([value intValue] >= [self.optionsInUse smallestMegaCase]) weight = 1.5;
        accum += [value intValue] * weight;
    }
    avg = accum / (double)countValuesOpened;
    // Worry factor
    int bad = 0, good = 0;
    for (NSNumber* value in [self.valuesOpened subarrayWithRange:(NSRange){countValuesOpened-6, 6}]) {
        if ([value intValue] < [self.optionsInUse worrySmall]) good++;
        if ([value intValue] > [self.optionsInUse worryLarge]) bad++;
    }
    if (bad >= 5) { avg *= 0.85; }
	if (good >= 5) { avg *= 1.15; }
    NSNumber* offer;
    if (avg > 100) {
        if (avg < 1000) offer = [NSNumber numberWithInt:((int)roundf(avg/10.) * 10)];
        else if (avg < 10000) offer = [NSNumber numberWithInt:((int)roundf(avg/100) * 100 + (rand() % 10 * 100))];
        else offer = [NSNumber numberWithInt:((int)roundf(avg/1000) * 1000 + (rand() % 10 * 1000))];
    } else {
        offer = [NSNumber numberWithInt:((int)avg + (rand() % 10))];
    }
	//if (isend != 1) {
    
	//}
	return offer;
}

- (NSNumber*) makeOffer {
    char dond;
    [self printValueBoard];
    NSNumber *offer = [self calculateOfferValue];
    // Leaving the assignment of maximumOffered here, since this is only called when the contestant can
    // actually decline or accept the offer.
    if ([offer compare:self.maximumOffered] == NSOrderedDescending) self.maximumOffered = [offer copy];
    BNBDealer* dealer = [self.optionsInUse getRandomDealer];
    printf("%s makes an offer:\n", [[dealer name] UTF8String]);
    printf("    \"%s\"\n", [[dealer getRandomTalk] UTF8String]);
    printf("\nThe offer is %s for your case. Take it (y/n)? ", [self.optionsInUse formatNumberAsCurrency:offer]);
    getchar();
    scanf("%c", &dond);
    if (dond == 'y' || dond == 'Y') {
        printf("Deal!\n");
        return offer;
    } else {
        printf("No deal!\n");
        return nil;
    }
}

- (void) handleTheOffer {
    // offerMade becomes YES once an offer is accepted. Once set to YES, the 'end game'
    // (in which hypothetical offers are made... the 'what if' round) begins.
    if (self.offerTaken == NO) {
        NSNumber* offer = [self makeOffer];
        if (offer != nil) { // if contestant took the offer
            self.offerTaken = YES;
            self.valueOfOfferTaken = [offer copy];
            char opt;
            printf("Care to see what would have happened if you had not taken the offer? (y/n) ");
            getchar();
            scanf("%c", &opt);
            if (opt == 'N' || opt == 'n') {
                NSNumber *ownValue = [self.ownCase value];
                printf("Your case contained %s and you settled for %s.\n", [self.optionsInUse formatNumberAsCurrency:ownValue], [self.optionsInUse formatNumberAsCurrency:offer]);
                if ([ownValue compare:offer] == NSOrderedDescending) {
                    printf("You made a crappy deal.\n");
                    if ([self.maximumOffered compare:offer] == NSOrderedDescending) {
                        printf("Furthermore, you were offered as much as %s for the case and turned that down too!\n", [self.optionsInUse formatNumberAsCurrency:self.maximumOffered]);
                    }
                } else {
                    printf("You made a great deal!\n");
                }
                printf("Game over.\n");
                exit(0);
            }
        }
    } else { // Simply show the hypothetical value and open another case.
        NSNumber* offer = [self calculateOfferValue];
        [self printValueBoard];
        printf("\nYour offer at this point would have been %s.\n\n", [self.optionsInUse formatNumberAsCurrency:offer]);
    }
    return;
}

- (void) dump {
    for (BNBCase *thisCase in self.caseObjects) {
        NSString* output = [thisCase dumpContentsIntoNSString];
        printf("%s\n", [output UTF8String]);
    }
}

@end