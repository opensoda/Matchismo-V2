//
//  Card.h
//  Matchismo
//
//  Created by Scott Rogers on 27/06/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isFaceUp) BOOL faceUp;

@property (nonatomic, getter=isUnplayable) BOOL unplayable;

- (NSString *)description;

- (int)match:(NSArray *)othercards;

@end