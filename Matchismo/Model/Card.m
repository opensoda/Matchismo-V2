//
//  Card.m
//  Matchismo
//
//  Created by Scott Rogers on 27/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSString *)description
{
    return self.contents;
}

- (int)match:(NSArray *)othercards
{    
    int score = 0;
    
    for (Card *card in othercards)
    {
        if([card.contents isEqualToString:self.contents])
        {
            score = 1;
            break;
        }
    }
    
    return score;
}

@end
