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

- (Deck *)createDeck;    // abstract
- (GameType)gameType; // abstract
- (MatchingMode)matchingMode; // abstract
- (int)matchBonus; // abstract
- (int)mismatchPenalty; // abstract
- (int)flipCost; // abstract

- (NSAttributedString *)attributedStringForCard:(Card *)card; // abstract

- (void)updateCardButton:(UIButton *)cardButton
                withCard:(Card *)card; // abstract

@end
