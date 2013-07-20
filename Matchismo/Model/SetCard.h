//
//  SetCard.h
//  Matchismo
//
//  Created by Scott Rogers on 18/07/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "Card.h"

typedef NS_ENUM(int, SetNumber) {
    SetNumberOne = 1,
    SetNumberTwo,
    SetNumberThree 
};

typedef NS_ENUM(int, SetSymbol) {
    SetSymbolDiamond,
    SetSymbolSquiggle,
    SetSymbolOval
};


typedef NS_ENUM(int, SetShading) {
    SetShadingSolid,
    SetShadingStriped,
    SetShadingOpen
};

typedef NS_ENUM(int, SetColor) {
    SetColorRed,
    SetColorGreen,
    SetColorPurple
};

@interface SetCard : Card

@property (nonatomic)SetNumber number;
@property (nonatomic)SetSymbol symbol;
@property (nonatomic)SetShading shading;
@property (nonatomic)SetColor color;

@end
