//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Scott Rogers on 28/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSMutableArray *flipCards;
@property (nonatomic, readwrite) int flipScore;
@end

@implementation CardMatchingGame

#define MATCH_EASY_BONUS 2          // match 2 cards out of 3
#define MATCH_MEDIUM_BONUS 4        // match 2 cards out of 2
#define MATCH_DIFFICULT_BONUS 8     // match 3 cards out of 3
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flipCards {
    if (!_flipCards) _flipCards = [[NSMutableArray alloc] init];
    return _flipCards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    
    self.flipCards = nil;
    self.flipScore = 0;
    BOOL matchChecked = NO;
    
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            
            [self.flipCards addObject:card];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    [self.flipCards addObject:otherCard];
                    
                    // depending on playMode check for a two or three card match
                    if (self.playMode == Two_Card_Match && self.flipCards.count == 2) {
                        
                        // check for a two card match...
                        int matchScore = [self.flipCards[0] match:@[self.flipCards[1]]];
                        if (matchScore) {
                            for(Card *matchedCard in self.flipCards) {
                                matchedCard.unplayable = YES;
                            }
                            self.flipScore = matchScore * MATCH_MEDIUM_BONUS;
                        } else {
                            ((Card *)self.flipCards[1]).faceUp = NO;
                            self.flipScore = matchScore - MISMATCH_PENALTY;
                        }
                        self.score += self.flipScore;
                        matchChecked = YES;
                        
                    }
                    else if (self.playMode == Three_Card_Match && self.flipCards.count == 3) {
                        
                        // check for a three card match...
                        int matchScore = [self.flipCards[0] match:@[self.flipCards[1]]];
                        matchScore += [self.flipCards[1] match:@[self.flipCards[2]]];
                        matchScore += [self.flipCards[0] match:@[self.flipCards[2]]];
                        
                        if (matchScore) {
                            for(Card *matchedCard in self.flipCards) {
                                matchedCard.unplayable = YES;
                            }
                            
                            int matchBonus = 0;
                            switch (matchScore) {
                                case 1:         // 1 suit match
                                case 4:         // 1 rank match
                                    matchBonus = MATCH_EASY_BONUS;
                                    break;
                                case 5:         // 1 suit match & 1 rank match
                                    matchBonus = MATCH_MEDIUM_BONUS;
                                    break;
                                case 3:         // 3 suit matches
                                case 12:        // 3 rank matches
                                    matchBonus = MATCH_DIFFICULT_BONUS;
                                    break;
                                default:
                                    break;
                            }
                            self.flipScore = matchScore *  matchBonus;
                        } else {
                            ((Card *)self.flipCards[1]).faceUp = NO;
                            ((Card *)self.flipCards[2]).faceUp = NO;
                            self.flipScore = matchScore - MISMATCH_PENALTY;
                        }
                        self.score += self.flipScore;
                        matchChecked = YES;
                    }
                }
                if (matchChecked) break;
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

@end
