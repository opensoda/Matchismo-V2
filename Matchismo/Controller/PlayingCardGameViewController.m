//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 20/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()


@end

@implementation PlayingCardGameViewController

#define STARTING_CARD_COUNT 24

- (NSUInteger)startingCardCount {
    return STARTING_CARD_COUNT;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (GameType)gameType {
    return GameType_MatchCardGame;
} 

- (MatchingMode)matchingMode {
    return [CardGameSettings integerValueForKey:MATCHCARDGAME_MATCHINGMODE_KEY];
}

- (int)matchBonus {
    return [CardGameSettings integerValueForKey:MATCHCARDGAME_MATCHBONUS_KEY];
}

- (int)mismatchPenalty {
    return [CardGameSettings integerValueForKey:MATCHCARDGAME_MISMATCHPENALTY_KEY];
}

- (int)flipCost {
    return [CardGameSettings integerValueForKey:MATCHCARDGAME_FLIPCOST_KEY];
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            
            if (animate) {
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{  playingCardView.faceUp = playingCard.isFaceUp;  }
                                completion:NULL];
            } else {
               playingCardView.faceUp = playingCard.isFaceUp; 
            }
            
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (NSAttributedString *)attributedStringForCard:(Card *)card {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:playingCard.contents]];
    }
    return attributedString;
}

@end
