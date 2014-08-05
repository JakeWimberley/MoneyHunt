//
//  main.m
//  BONB
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "main.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // Initialize case array. The default init method is to assign a random value from the list of values in Case.h
        NSMutableArray *cases = [[NSMutableArray alloc] init];
        // Set up an array to store the values of the opened cases (for use in making offers)
        NSMutableArray *valuesOpened = [[NSMutableArray alloc] init];
        for (int i = 0; i < numberOfCaseValues; i++) {
            [cases addObject:[[BNBCase alloc] init]];
        }
        // Debug routine: dump case values
        if (debugging) {
            for (int i = 0; i < numberOfCaseValues; i++) {
                NSString* output = [cases[i] dumpContentsIntoNSString];
                printf("%s\n", [output UTF8String]);
            }
        }
        printf("It's time to play... BLANK or NO BLANK.\n");
        printValueBoard(cases);
        printNumberBoard(cases);
        BNBCase* ownCase = pickCaseToHold(cases);
        // Round 1: A series of cases is opened before receiving an offer.
        //          The number of cases decreases in each series, with the last series having 2 cases.
        for (int numberInSeries = seriesInRound1; numberInSeries > 1; numberInSeries--) {
            int turn = 0;
            while (turn < numberInSeries) {
                printf("Cases left to open before offer: %i\n", numberInSeries - turn);
                printNumberBoard(cases);
                pickCaseToOpen(cases,valuesOpened);
                turn++;
            }
            handleTheOffer(ownCase,cases,valuesOpened);
        }
        // Round 2: Make an offer every time a case is opened.
        //          Stop when there is 1 case left unopened.
        NSUInteger numberOfCasesInRound2 = [getRemainingCaseNumbers(cases) count] - 1;
        for (int numberInSeries = 0; numberInSeries < numberOfCasesInRound2; numberInSeries++) {
            printNumberBoard(cases);
            pickCaseToOpen(cases,valuesOpened);
            handleTheOffer(ownCase,cases,valuesOpened);
        }
        // If we get here, the contestant held out all the way to the end.
        printf("Your confidence impresses me.\n");
        printf("The value of your case was: $%i\n", [[ownCase value] intValue]);
        printf("Game over.\n");
    }
    return 0;
}

NSArray* getRemainingValues(NSMutableArray *cases) {
    NSPredicate *isNotOpened = [NSPredicate predicateWithFormat:@"playStatus = %i", UNOPENED];
    NSArray *remainingCases = [cases filteredArrayUsingPredicate:isNotOpened];
    NSSortDescriptor *sortByValue;
    sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    return [remainingCases sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]];
}

NSArray* getRemainingCaseNumbers(NSMutableArray *cases) {
    NSPredicate *isNotOpened = [NSPredicate predicateWithFormat:@"playStatus = %i", UNOPENED];
    NSArray *remainingCases = [cases filteredArrayUsingPredicate:isNotOpened];
    NSSortDescriptor *sortByNumber;
    sortByNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    return [remainingCases sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByNumber]];
}

void printValueBoard(NSMutableArray *cases) {
    /* print remaining denominations in two columns like on TV
       thus, this loop steps through the first half of cases[] only
       note getRemainingValues is not used since spaces need to be printed in lieu of cases not in play */
    NSSortDescriptor *sortByValue;
    sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    NSArray *sortedCases = [cases sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]];
    NSUInteger numberOfDisplayRows = numberOfCaseValues / 2 + (numberOfCaseValues & 1);
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

void printNumberBoard(NSMutableArray *cases) {
    NSArray* casesInPlay = getRemainingCaseNumbers(cases);
    printf("\n");
    for (BNBCase* thisCase in casesInPlay) {
        printf("%i ", [[thisCase number] intValue]);
    }
    printf("\n\n");
}

BNBCase* pickCaseToHold(NSMutableArray *cases) {
    printf("Pick a case to hold for yourself: ");
	int x = 0;
	while (1) {
		scanf("%i", &x);
        for (BNBCase* thisCase in cases) {
            if ([thisCase chooseAndReturnYesIfNumberMatches:[NSNumber numberWithInt:x]]) return thisCase;
        }
        printf("No such case. Try again: ");
    }
}

NSNumber* pickCaseToOpen(NSMutableArray *cases, NSMutableArray *valuesOpened) {
    printf("Pick a case to open: ");
    int x = 0;
    NSNumber* returnValue = nil;
    while (1) {
		scanf("%i", &x);
        for (BNBCase* thisCase in cases) {
            returnValue = [thisCase openAndReturnValueIfNumberMatches:[NSNumber numberWithInt:x]];
            if (returnValue != nil) {
                printf("That case contained...      $%i\n", [returnValue intValue]);
                [valuesOpened addObject:returnValue];
                return returnValue;
            }
        }
        printf("You can't pick that case. Try again: ");
    }
}

NSNumber* calculateOfferValue(NSMutableArray *cases, NSMutableArray *valuesOpened) {
    /* three components of offer:
     rounded weighted average of remaining cases,
     "worry factor" - a string of low choices by the contestant
                      makes offer go higher,
     random value, m * 10**n,  where 1 <= m <= 9 and 1 <= n <= 3 */
	int accum = 0;
	double avg = 0.0;
    NSUInteger countValuesOpened = [valuesOpened count]; //TODO check value ==0
    // Weighted average
    NSArray* remainingValues = getRemainingValues(cases);
    for (BNBCase *_case in remainingValues) {
        NSNumber *value = [_case value];
        double weight = 1;
        if ([value intValue] <= biggestPicoCase) weight = 4;
        else if ([value intValue] <= biggestNanoCase) weight = 3;
        else if ([value intValue] <= biggestMicroCase) weight = 2;
        if ([value intValue] >= smallestMegaCase) weight = 1.5;
        accum += [value intValue] * weight;
    }
    avg = accum / (double)countValuesOpened;
    // Worry factor
    int bad = 0, good = 0;
    for (NSNumber* value in [valuesOpened subarrayWithRange:(NSRange){countValuesOpened-6, 6}]) {
        if ([value intValue] < worrySmall) good++;
        if ([value intValue] > worryLarge) bad++;
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

NSNumber* makeOffer(NSMutableArray *cases, NSMutableArray *valuesOpened) {
    char dond;
    printValueBoard(cases);
    NSNumber *offer = calculateOfferValue(cases, valuesOpened);
    printf("\n%s offers you $%i for your case. Take the deal (y/n)? ", [dealerName UTF8String], [offer intValue]);
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

void handleTheOffer(BNBCase* ownCase, NSMutableArray* cases, NSMutableArray* valuesOpened) {
    // offerMade becomes YES once an offer is accepted. Once set to YES, the 'end game'
    // (in which hypothetical offers are made... the 'what if' round) begins.
    static BOOL offerTaken = NO;
    if (offerTaken == NO) {
        NSNumber* offer = makeOffer(cases, valuesOpened);
        if (offer != nil) { // if contestant took the offer
            offerTaken = YES;
            char opt;
            printf("Care to see what would have happened if you had not taken the offer? (y/n) ");
            getchar();
            scanf("%c", &opt);
            if (opt == 'N' || opt == 'n') {
                int ownValue = [[ownCase value] intValue];
                printf("Your case contained $%i and you settled for $%i.\n", ownValue, [offer intValue]);
                if (ownValue > [offer intValue]) {
                    printf("You made a crappy deal.\n");
                } else {
                    printf("You made a great deal!\n");
                }
                printf("Game over.\n");
                exit(0);
            }
        }
    } else { // Simply show the hypothetical value and open another case.
        NSNumber* offer = calculateOfferValue(cases, valuesOpened);
        printValueBoard(cases);
        printf("\nYour offer at this point would have been $%i.\n\n", [offer intValue]);
    }
    return;
}

