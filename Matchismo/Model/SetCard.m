//
//  SetCard.m
//  Matchismo
//
//  Created by Scott Rogers on 18/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)othercards {

    int score = 0;
    
    if ([othercards count] == 2) {
        
        SetCard *card1 = self;
        SetCard *card2 = (SetCard *)othercards[0];
        SetCard *card3 = (SetCard *)othercards[1];
        
        // cards match a set...
        if (
            // all same number
            ((card1.number == card2.number &&
             card2.number == card3.number &&
             card1.number == card3.number)
            ||
            // all different number
            (card1.number != card2.number &&
             card2.number != card3.number &&
             card1.number != card3.number))
            &&
            // all same symbol
            ((card1.symbol == card2.symbol &&
             card2.symbol == card3.symbol &&
             card1.symbol == card3.symbol)
            ||
            // all different symbol
            (card1.symbol != card2.symbol &&
             card2.symbol != card3.symbol &&
             card1.symbol != card3.symbol))
            &&
            // all same shading
            ((card1.shading == card2.shading &&
             card2.shading == card3.shading &&
             card1.shading == card3.shading)
            ||
            // all different shading
            (card1.shading != card2.shading &&
             card2.shading != card3.shading &&
             card1.shading != card3.shading))
            &&
            // all same color
            ((card1.color == card2.color &&
             card2.color == card3.color &&
             card1.color == card3.color)
            ||
            // all different color
            (card1.color != card2.color &&
             card2.color != card3.color &&
             card1.color != card3.color))

            ) score = 1;
    }
    return score;
}

// Overriding NSObject's description function
- (NSString *)description
{
    return [self contents];
}

// Overriding Card's contents function
- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d-%d-%d-%d", self.number, self.symbol, self.color, self.shading];
}

@end
