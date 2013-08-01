//
//  PlayingCard.m
//  Matchismo
//
//  Created by Scott Rogers on 27/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)othercards {
    
    int score = 0;
    PlayingCard *playingCard1 = self;
    
    if ([othercards count] == 1) {
        id otherCard = [othercards lastObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard2 = (PlayingCard *)otherCard;
            if ([playingCard1.suit isEqualToString:playingCard2.suit]) {
                score += 1;
            } else if (playingCard1.rank == playingCard2.rank) {
                score += 4;
            }
        }
    } else if ([othercards count] == 2) {
        id otherCard2 = othercards[0];
        id otherCard3 = othercards[1];
        if ([otherCard2 isKindOfClass:[PlayingCard class]] && [otherCard3 isKindOfClass:[PlayingCard class]] ) {
            PlayingCard *playingCard2 = (PlayingCard *)otherCard2;
            PlayingCard *playingCard3 = (PlayingCard *)otherCard3;
            score += [playingCard1 match:@[playingCard2]];
            score += [playingCard2 match:@[playingCard3]];
            score += [playingCard1 match:@[playingCard3]];
        }
    }
    
    return score;
}

- (NSString *)contents {
    return [[PlayingCard rankStrings] [self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we are implementing both the getter and setter

+ (NSArray *)validSuits {
    static NSArray *validSuits = nil;
    if(!validSuits) validSuits = @[@"♠",@"♣",@"♥",@"♦"];
    return validSuits;
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
