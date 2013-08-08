//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Scott Rogers on 26/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "CardGameSettings.h"
#import "Deck.h"


@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic, readonly) int flipCount;
@property (nonatomic)int startingCardCount; // abstract
@property (nonatomic)int moreCardCount; // abstract

- (Deck *)createDeck;    // abstract
- (GameType)gameType; // abstract
- (MatchingMode)matchingMode; // abstract
- (int)matchBonus; // abstract
- (int)mismatchPenalty; // abstract
- (int)flipCost; // abstract
- (BOOL)deleteCardMatches; // abstract

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate; // abstract

- (NSString *)cellReuseIdentifier; //abstract

- (NSAttributedString *)attributedStringForCard:(Card *)card; // abstract

@end
