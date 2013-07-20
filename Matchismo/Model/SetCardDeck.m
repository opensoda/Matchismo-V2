//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Scott Rogers on 18/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id) init {
    self = [super init];
    
    if (self)
    {
        for (int number = SetNumberOne; number <= SetNumberThree; number++) {
            for (int symbol = SetSymbolDiamond; symbol <= SetSymbolOval; symbol++ ) {
                for (int shading = SetShadingSolid; shading <= SetShadingOpen; shading++) {
                    for (int color = SetColorRed; color <= SetColorPurple; color++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = (SetNumber)number;
                        card.symbol = (SetSymbol)symbol;
                        card.shading = (SetShading)shading;
                        card.color = (SetColor)color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
