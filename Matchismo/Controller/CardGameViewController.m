//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 26/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource>

#define FLIP_CARD_AT_INDEX_ALL_CARDS -1
@property (nonatomic) int flipCardAtIndex;

@property (nonatomic, readwrite) int flipCount;

@property (strong, nonatomic) CardGameResult *gameResult;

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic) int insertedVersusDeletedCellCount;

@property (weak, nonatomic) IBOutlet UILabel *flipResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)deal:(UIButton *)sender;

@end

@implementation CardGameViewController

// UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
} // optional - if not implemented will use default of 1

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.game cardsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate {
    
} // abstract

- (int)moreCardCount {
    return 0;
} // abstract

- (NSString *)cellReuseIdentifier {
    return nil;
} // abstract

- (NSAttributedString *)attributedStringForCard:(Card *)card {
    return nil;
} // abstract

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount: self.startingCardCount
                                                          usingDeck:[self createDeck]
                                                           gameType:[self gameType]
                                                       matchingMode:[self matchingMode]
                                                         matchBonus:[self matchBonus]
                                                    mismatchPenalty:[self mismatchPenalty]
                                                           flipCost:[self flipCost]];
    return _game;
}

- (CardGameResult *)gameResult {
    if(!_gameResult) {
        _gameResult = [[CardGameResult alloc] init];
        _gameResult.gameType = [CardMatchingGame stringForGameType:self.game.gameType];
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

- (int)matchBonus {
    return 0;
} // abstract

- (int)mismatchPenalty {
    return 0;
} // abstract

- (int)flipCost {
    return 0;
} // abstract

- (BOOL)deleteCardMatches {
    return NO;
} // abstract


- (void)insertCellsForCardCount:(int)cardCount {
    if (cardCount > 0) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int row = self.game.cardsCount - cardCount ; row < self.game.cardsCount; row++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
        self.insertedVersusDeletedCellCount += [indexPaths count];
    }     
}

- (void)deleteCellsForCardCount:(int)cardCount {
    if (cardCount > 0) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int row = 0; row < cardCount; row++ ) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
        self.insertedVersusDeletedCellCount -= [indexPaths count];
    }
}

- (void)setFlipCardAtIndex:(int)flipCardAtIndex {
    _flipCardAtIndex = flipCardAtIndex;
    [self updateUI];
}

- (void)updateUI {
    [self updateCards];
    [self updateLabels];
}

- (void)updateCards {
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        BOOL animate = (self.flipCardAtIndex == indexPath.item) || (self.flipCardAtIndex == FLIP_CARD_AT_INDEX_ALL_CARDS);
        [self updateCell:cell usingCard:card animate:animate];
    }
}

- (void)updateLabels {
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
        
        if ([self.game.flippedCards count] == 0) { // no cards flipped up
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@""]];
            
        } else if (self.game.flipScore == 0) { // flipped card(s)
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up " ]];
            [results appendAttributedString:cardsToInsert];
            
        } else if (self.game.flipScore > 0) { // matched card(s)
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched " ]];
            [results appendAttributedString:cardsToInsert];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"! +%d points!", self.game.flipScore]]];
            
        } else if (self.game.flipScore < 0) { // mis-matched card(s)
            [results appendAttributedString:cardsToInsert];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:@" don't match!" ]];
            [results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d points!", self.game.flipScore]]];
        }
    }
    
    self.flipResultsLabel.attributedText = results;
    self.flipResultsLabel.hidden = self.flipCount == 0;
    
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)updateDealButton {
    self.dealButton.tintColor = (int)[self.game deckCardsCount] > 0 ? nil : [UIColor redColor];
}

- (IBAction)dealMoreCardsOnSwipe:(UISwipeGestureRecognizer *)sender {
    [self dealMoreCards];
}

- (void)dealMoreCards {
    int cardCount = ((int)[self.game deckCardsCount] - (int)[self moreCardCount]) < 0 ? [self.game deckCardsCount] : [self moreCardCount];
    [self.game dealCardCount:cardCount];
    [self insertCellsForCardCount:cardCount];
    
    [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.game.cardsCount - 1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    [self updateDealButton];
}

- (IBAction)flipCardOnSwipe:(UISwipeGestureRecognizer *)gesture {
    [self flipCard:gesture];
}

- (IBAction)flipCardOnTap:(UITapGestureRecognizer *)gesture {
    [self flipCard:gesture];
}

- (void)flipCard:(UIGestureRecognizer *)gesture {
    CGPoint gestureLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:gestureLocation];
    
    if (indexPath) {
        Card *card = [self.game cardAtIndex:indexPath.item];
        if (!card.isUnplayable) {
            [self.game flipCardAtIndex:indexPath.item];
            self.gameResult.score = self.game.score;
            self.flipCount++;
            if ([self deleteCardMatches] && [self flippedCardsMatch]) {
                // delete cards from game
                for (Card *card in self.game.flippedCards) {
                    [self.game deleteCardAtIndex:[self.game indexOfCard:card]];
                }
                
                [self deleteCellsForCardCount:[self.game.flippedCards count]];
            }
            self.flipCardAtIndex = indexPath.item;
        }
    }
}

- (BOOL)flippedCardsMatch {
    return  self.game.flipScore > 0;
}

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    
    if (self.insertedVersusDeletedCellCount > 0) {
        [self deleteCellsForCardCount:self.insertedVersusDeletedCellCount];
    } else if (self.insertedVersusDeletedCellCount < 0) { 
        [self insertCellsForCardCount:(self.insertedVersusDeletedCellCount * -1)];
    }

    self.flipCardAtIndex = FLIP_CARD_AT_INDEX_ALL_CARDS;
    [self updateDealButton];
}


@end
