//
//  main.m
//  Money Hunt
//
//  Copyright (c) 2014 Jake Wimberley. All rights reserved.
//

#import "main.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        BNBOptions *options = [[BNBOptions alloc] init];
        BNBCaseArray *cases = [[BNBCaseArray alloc] initWithOptions:options];
        printf("It's time to play MONEY HUNT!\n");
        [cases printValueBoard];
        [cases printNumberBoard];
        [cases pickCaseToHold];
        // Round 1: A series of cases is opened before receiving an offer.
        //          The number of cases decreases in each series, with the last series having 2 cases.
        for (int numberInSeries = options.numberOfSeriesInRound1; numberInSeries > 1; numberInSeries--) {
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
        // Post-game: If contestant did not take any offers, or did take an offer but did not decline the opportunity
        //            to find out what would have happened if they kept playing, reveal the final results.
        printf("The value of your case was %s.\n", [options formatNumberAsCurrency:[[cases ownCase] value]]);
        if ([cases offerTaken] == YES) {
            printf("You sold it for %s.\n", [options formatNumberAsCurrency:cases.valueOfOfferTaken]);
            if ([cases.valueOfOfferTaken compare:[cases.ownCase value]] != NSOrderedAscending) {
                printf("Great job!\n");
                if ([cases.valueOfOfferTaken compare:cases.maximumOffered] != NSOrderedAscending) {
                    printf("But you would have made more if you took the offer for %s.\n", [options formatNumberAsCurrency:cases.maximumOffered]);
                }
            } else {
                printf("Bummer!\n");
            }
        } else {
            printf("Your confidence impresses me.\n");
            printf("You turned down all those offers, as much as %s, but you stuck to your guns.\n", [options formatNumberAsCurrency:cases.maximumOffered]);
            if ([[[cases ownCase] value] compare:cases.maximumOffered] != NSOrderedDescending) {
                printf("Way to go!\n");
            } else {
                printf("You blew it!\n");
            }
            printf("Game over.\n");
        }
    }
    return 0;
}