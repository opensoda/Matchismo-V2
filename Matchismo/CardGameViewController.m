//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Rogers on 26/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
    
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.selected)
    {
        Card *card = [self.deck drawRandomCard];
        [sender setTitle:card.contents forState:UIControlStateSelected];
        NSLog(@"random card drawn from deck");
    }
    
    self.flipCount++;
}


@end
