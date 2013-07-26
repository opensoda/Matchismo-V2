//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 26/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameViewController.h"


#import "GameResult.h"

@interface CardGameViewController ()

@property (nonatomic, readwrite) int flipCount;
@property (strong, nonatomic) GameResult *gameResult;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)deal:(UIButton *)sender;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[self createDeck]
                                                           gameType:[self gameType]
                                                       matchingMode:[self matchingMode]];
    return _game;
}

- (GameResult * )gameResult {
    if(!_gameResult) {
        _gameResult = [[GameResult alloc] init];
        _gameResult.gameType = [self.game gameTypeToString];
    }
    return _gameResult;
}

- (Deck *)createDeck {     
    return nil;
}   // abstract

- (GameType)gameType {
    return GameType_Unknown;
} // abstract

- (MatchingMode)matchingMode {
    return MatchingMode_Unknown;
} // abstract

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    [self updateCardButtons];
    [self updateFlipResults];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    [self updateSubClassUI];
}

- (void)updateSubClassUI {
}

- (void)updateCardButtons {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateCardButton:cardButton
                      withCard:card];
    }
}

- (void)updateCardButton:(UIButton *)cardButton
                withCard:(Card *)card {
    
} // abstract

- (NSAttributedString *)attributedStringForCard:(Card *)card {
    return nil;
} // abstract

- (void)updateFlipResults {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSMutableAttributedString *results = [[NSMutableAttributedString alloc] initWithString:@" " attributes:attributes];

    if (self.flipCount > 0) {
        NSMutableAttributedString *cardsToInsert = [[NSMutableAttributedString alloc] init];
        
        for (Card *card in self.game.flippedCards) {
            [cardsToInsert appendAttributedString:[self attributedStringForCard:card]];
            if (![card isEqual:[self.game.flippedCards lastObject]]) [cardsToInsert appendAttributedString:[[NSAttributedString alloc] initWithString:@"&"]];
        }
        
        if (self.game.flippedCards.count == 0) { // no cards flipped up
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@""]];
            
        } else if (self.game.flipScore == 0) { // flipped card(s)
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up " ]];
            [results appendAttributedString:cardsToInsert];
            
        } else if (self.game.flipScore > 0) { // matched card(s)
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched " ]];
            [results appendAttributedString:cardsToInsert];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", self.game.flipScore]]];
            
        } else if (self.game.flipScore < 0) { // mis-matched card(s)
            [results appendAttributedString:cardsToInsert];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@" don't match!" ]];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d point penalty!", self.game.flipScore]]];
        }
    }
    
    self.flipResultsLabel.attributedText = results;
    self.flipResultsLabel.hidden = self.flipCount == 0;
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.gameResult.score = self.game.score;
    self.flipCount++;
    [self updateUI];
    
}

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}


@end
