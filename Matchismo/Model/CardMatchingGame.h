//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Scott Rogers on 28/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

typedef NS_ENUM(NSInteger, GameType) {
    GameType_Unknown,
    GameType_MatchCardGame,
    GameType_SetCardGame
};

typedef NS_ENUM(NSInteger, MatchingMode) {
    MatchingMode_Unknown,
    MatchingMode_TwoCardMatch = 2,
    MatchingMode_ThreeCardMatch = 3
};

@interface CardMatchingGame : NSObject

@property (nonatomic) GameType gameType;
@property (nonatomic) MatchingMode matchingMode;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@property (nonatomic, readonly) int score;

@property (strong, nonatomic, readonly) NSMutableArray *flippedCards;
@property (nonatomic, readonly) int flipScore;

+ (NSString *)stringForGameType:(GameType)gameType;

// designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

// convenience initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
           gameType:(GameType)gameType
           matchingMode:(MatchingMode)matchingMode
             matchBonus:(int)matchBonus
        mismatchPenalty:(int)mismatchPenalty
               flipCost:(int)flipCost;

- (void)flipCardAtIndex:(NSUInteger)index;

- (void)deleteCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfCard:(Card *)card;

- (NSUInteger)cardsCount;

- (void)dealCardCount:(NSUInteger)cardCount;






@end
