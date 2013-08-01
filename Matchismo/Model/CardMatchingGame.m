//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Scott Rogers on 28/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSMutableArray *flippedCards;
@property (nonatomic, readwrite) int flipScore;

@end

@implementation CardMatchingGame

+ (NSString *)stringForGameType:(GameType)gameType {
    
    NSString *gameTypeString = @"";
    
    switch (gameType) {
        case GameType_Unknown:
            gameTypeString = @"Unknown";
            break;
        case GameType_MatchCardGame:
            gameTypeString = @"Match";
            break;
        case GameType_SetCardGame:
            gameTypeString = @"Set";
            break;
        default:
            break;
    }
    return gameTypeString;
}


- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flippedCards {
    if (!_flippedCards) _flippedCards = [[NSMutableArray alloc] init];
    return _flippedCards;
}

// designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        self.deck = deck;
        for (int i = 0; i < cardCount; i++) {
            Card *card = [self.deck drawRandomCard];
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

// convenience initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
               gameType:(GameType)gameType
           matchingMode:(MatchingMode)matchingMode
             matchBonus:(int)matchBonus
        mismatchPenalty:(int)mismatchPenalty
               flipCost:(int)flipCost {
    
    self = [self initWithCardCount:cardCount usingDeck:deck];
    
    if (self) {
        self.gameType = gameType;
        self.matchingMode = matchingMode;
        self.matchBonus = matchBonus;
        self.mismatchPenalty = mismatchPenalty;
        self.flipCost = flipCost;
    }
    
    return self;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    
    self.flippedCards = nil;
    self.flipScore = 0;
    BOOL matchChecked = NO;
    
    Card *card = [self cardAtIndex:index];
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            
            [self.flippedCards addObject:card];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    [self.flippedCards addObject:otherCard];
                    [otherCards addObject:otherCard];
                    
                    // depending on matchingMode check for a two or three card match
                    if ((self.matchingMode == MatchingMode_TwoCardMatch && [self.flippedCards count] == 2)||
                        (self.matchingMode == MatchingMode_ThreeCardMatch && [self.flippedCards count] == 3)) {
                        
                        int matchScore = [card match:otherCards];
                        
                        if (matchScore) {
                            for(Card *matchedCard in self.flippedCards) {
                                matchedCard.unplayable = YES;
                            }
                            self.flipScore = [self applyMatchBonusToMatchScore:matchScore];
                        } else {
                            for(Card *otherCard in otherCards) {
                                otherCard.faceUp = NO;
                            }
                            self.flipScore -= self.mismatchPenalty;
                        }
                        self.score += self.flipScore;
                        matchChecked = YES;
                    }
                }
                if (matchChecked) break;
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (void)deleteCardAtIndex:(NSUInteger)index {
    if (index < [self.cards count]) {
        [self.cards removeObjectAtIndex:index];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSUInteger)indexOfCard:(Card *)card {
    return [self.cards indexOfObject:card];
}

- (NSUInteger)cardsCount {
    return [self.cards count];
}

- (void)dealCardCount:(NSUInteger)cardCount {
    for (int i = 0; i < cardCount; i++) {
        Card *card = [self.deck drawRandomCard];
        if(card) {
            [self.cards addObject:card];
        }
    }
}

- (int)applyMatchBonusToMatchScore:(int)matchScore {
    
    int matchBonus = 0;
    
    if (self.gameType == GameType_MatchCardGame) {
        
        if (self.matchingMode == MatchingMode_TwoCardMatch) {
            matchBonus = self.matchBonus;
        }
        else if (self.matchingMode == MatchingMode_ThreeCardMatch)
        {
            switch (matchScore) {
                case 1:         // 1 suit match
                case 4:         // 1 rank match
                    matchBonus = self.matchBonus / 2;
                    break;
                case 5:         // 1 suit match & 1 rank match
                    matchBonus = self.matchBonus;
                    break;
                case 3:         // 3 suit matches
                case 12:        // 3 rank matches
                    matchBonus = self.matchBonus * 2;
                    break;
                default:
                    break;
            }
        }
    }
    else if (self.gameType == GameType_SetCardGame)
    {
        matchBonus = self.matchBonus;
    }
    
    return matchScore *  matchBonus;
}

@end
