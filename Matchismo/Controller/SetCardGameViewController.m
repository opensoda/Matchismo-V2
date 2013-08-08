//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 20/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

#define STARTING_CARD_COUNT 12
#define MORE_CARD_COUNT 3
#define CELL_REUSE_IDENTIFIER @"SetCard"

- (int)startingCardCount {
    return STARTING_CARD_COUNT;
}

- (int)moreCardCount {
    return MORE_CARD_COUNT;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (GameType)gameType {
    return GameType_SetCardGame;
}

- (MatchingMode)matchingMode {
    return MatchingMode_ThreeCardMatch;
}

- (int)matchBonus {
    return [CardGameSettings integerValueForKey:SETCARDGAME_MATCHBONUS_KEY];
}

- (int)mismatchPenalty {
     return [CardGameSettings integerValueForKey:SETCARDGAME_MISMATCHPENALTY_KEY];
}

- (int)flipCost {
     return [CardGameSettings integerValueForKey:SETCARDGAME_FLIPCOST_KEY];
}

- (BOOL)deleteCardMatches {
    return YES;
}

- (NSString *)cellReuseIdentifier {
    return CELL_REUSE_IDENTIFIER;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate {
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = (int)setCard.number;
            setCardView.symbol = (int)setCard.symbol;
            setCardView.shading = (int)setCard.shading;
            setCardView.color = (int)setCard.color;
            
            if (animate) {
                [UIView transitionWithView:setCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{  setCardView.faceUp = setCard.isFaceUp;  }
                                completion:NULL];
            } else {
                setCardView.faceUp = setCard.isFaceUp;
            }
            
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (NSAttributedString *)attributedStringForCard:(Card *)card {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSString *symbol;
        
        switch (setCard.symbol) {
            case SetSymbolOne :
                symbol = @"▲";
                break;
            case SetSymbolTwo :
                symbol = @"■";
                break;
            case SetSymbolThree :
                symbol = @"●";
                break;
            default: // unkown symbol
                symbol = @"?";
                break;
        }
        
        NSString *symbols = [symbol stringByPaddingToLength:setCard.number withString:symbol startingAtIndex:0];
        
        // build up attributes
        UIColor *color;
        
        switch(setCard.color) {
            case SetColorOne:
                color = [UIColor colorWithRed:1.00 green:0.10 blue:0.07 alpha:1.00];
                break;
            case SetColorTwo:
                color = [UIColor colorWithRed:0.00 green:0.84 blue:0.32 alpha:1.00];
                break;
            case SetColorThree: // purple
                color = [UIColor colorWithRed:0.42 green:0.15 blue:0.79 alpha:1.00];
                break;
            default: // unknown color
                color = [UIColor blackColor];
                break;
        }
        
        [attributes addEntriesFromDictionary:@{NSStrokeColorAttributeName : color}];
        
        // set a strokewidth
        [attributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5}];
        
        double alphaComponent;
        switch(setCard.shading) {
            case SetShadingOne:
                alphaComponent = 0.0;
                break;
            case SetShadingTwo:
                alphaComponent = 0.3;
                break;
            case SetShadingThree:
                alphaComponent = 1.0;
                break;
            default: // unknowm shading
                alphaComponent = 0.5;
                break;
        }
        
        [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:alphaComponent]}];
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:symbols attributes:attributes];
    }
    
    return attributedString;
}

@end
