//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Scott Rogers on 28/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

typedef NS_ENUM(NSInteger, PlayMode) {
    Two_Card_Match,
    Three_Card_Match
};

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic) PlayMode playMode;
@property (nonatomic, readonly) int score;

@property (strong, nonatomic, readonly) NSMutableArray *flipCards;
@property (nonatomic, readonly) int flipScore;


@end
