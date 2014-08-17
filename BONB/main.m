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
        BNBCaseArray *cases = [[BNBCaseArray alloc] init];
        printf("It's time to play... BLANK or NO BLANK.\n");
        [cases printValueBoard];
        [cases printNumberBoard];
        [cases pickCaseToHold];
        // Round 1: A series of cases is opened before receiving an offer.
        //          The number of cases decreases in each series, with the last series having 2 cases.
        for (int numberInSeries = seriesInRound1; numberInSeries > 1; numberInSeries--) {
            int turn = 0;
            while (turn < numberInSeries) {
                printf("Cases left to open before offer: %i\n", numberInSeries - turn);
                [cases printNumberBoard];
                [cases pickCaseToOpen];
                turn++;
            }
            [cases handleTheOffer];
        }
        // Round 2: Make an offer every time a case is opened.
        //          Stop when there is 1 case left unopened.
        NSUInteger numberOfCasesInRound2 = [[cases getRemainingCaseNumbers] count] - 1;
        for (int numberInSeries = 0; numberInSeries < numberOfCasesInRound2; numberInSeries++) {
            [cases printNumberBoard];
            [cases pickCaseToOpen];
            [cases handleTheOffer];
        }
        // If we get here, the contestant held out all the way to the end.
        printf("Your confidence impresses me.\n");
        printf("The value of your case was: $%i\n", [[[cases ownCase] value] intValue]);
        printf("You turned down all those offers, as much as $%i, but you stuck to your guns.\n", [cases.maximumOffered intValue]);
        if ([[[cases ownCase] value] compare:cases.maximumOffered] == NSOrderedAscending) {
            printf("You blew it!\n");
        } else {
            printf("Way to go!\n");
        }
        printf("Game over.\n");
    }
    return 0;
}