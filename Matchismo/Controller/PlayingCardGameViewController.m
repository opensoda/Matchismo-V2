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

@interface PlayingCardGameViewController ()

@property (strong, nonatomic) UIImage *cardbackImage;
@property (strong, nonatomic) IBOutlet UISegmentedControl *playModeSegmentedControl;

- (IBAction)playMode:(UISegmentedControl *)sender;

@end

@implementation PlayingCardGameViewController


- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (GameType)gameType {
    return GameType_MatchCardGame;
} 

- (MatchingMode)matchingMode {
    return self.playModeSegmentedControl.selectedSegmentIndex == 0 ? MatchingMode_TwoCardMatch : MatchingMode_ThreeCardMatch;
}

- (void)updateSubClassUI{
    [self updatePlayMode];
}

- (UIImage *)cardBackImage {
    if (!_cardbackImage) _cardbackImage = [UIImage imageNamed:@"cardback.png"];
    return _cardbackImage;
}

#define CARD_EDGE_INSET 6.0

- (void)updateCardButton:(UIButton *)cardButton
                withCard:(Card *)card {
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    
    if (!cardButton.selected) {
        [cardButton setImage:self.cardBackImage forState:UIControlStateNormal];
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(CARD_EDGE_INSET, CARD_EDGE_INSET, CARD_EDGE_INSET, CARD_EDGE_INSET);
    } else {
        [cardButton setImage:nil forState:UIControlStateNormal];
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

- (void)updatePlayMode {
    self.playModeSegmentedControl.hidden = self.flipCount > 0;
    if (self.flipCount == 0 ) {
        self.game.matchingMode = self.playModeSegmentedControl.selectedSegmentIndex == 0 ? MatchingMode_TwoCardMatch : MatchingMode_ThreeCardMatch;
    }
}

- (IBAction)playMode:(UISegmentedControl *)sender {
    
    [self updatePlayMode];
}



@end
