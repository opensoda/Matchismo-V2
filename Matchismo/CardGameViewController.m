//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 26/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController ()

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultsLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *playModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) GameResult *gameResult;

- (IBAction)playMode:(UISegmentedControl *)sender;
- (IBAction)deal:(UIButton *)sender;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (GameResult * )gameResult {
    if(!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    [self updateCardButtons];
    [self updateFlipResults];
    [self updatePlayMode];
    
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#define CARD_EDGE_INSET 6.0

- (void)updateCardButtons {
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        if (!cardButton.selected) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(CARD_EDGE_INSET, CARD_EDGE_INSET, CARD_EDGE_INSET, CARD_EDGE_INSET);
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
}

- (void)updateFlipResults {
    
    self.flipResultsLabel.hidden = self.flipCount == 0;
    
    if (self.flipCount > 0) {
        if (self.game.flipCards.count == 0) { // no cards flipped up
            self.flipResultsLabel.text = @"";
        } else if (self.game.flipScore == 0) { // flipped card(s)
            self.flipResultsLabel.text = [NSString stringWithFormat:@"Flipped up %@", [self.game.flipCards componentsJoinedByString:@","]];
        } else if (self.game.flipScore > 0) { // matched card(s)
            self.flipResultsLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points", [self.game.flipCards componentsJoinedByString:@","], self.game.flipScore];
        } else if (self.game.flipScore < 0) { // mis-matched card(s)
            self.flipResultsLabel.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [self.game.flipCards componentsJoinedByString:@"," ], self.game.flipScore];
        }
    }
}

- (void)updatePlayMode {
    self.playModeSegmentedControl.hidden = self.flipCount > 0;
    if (self.flipCount == 0 ) {
        self.game.playMode = self.playModeSegmentedControl.selectedSegmentIndex == 0 ? Two_Card_Match : Three_Card_Match;
    }
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (IBAction)playMode:(UISegmentedControl *)sender {
    
    [self updatePlayMode];
}

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}


@end
