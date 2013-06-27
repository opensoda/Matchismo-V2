//
//  Deck.h
//  Matchismo
//
//  Created by Scott Rogers on 27/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"    

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
