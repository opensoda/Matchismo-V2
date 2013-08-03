//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Scott Rogers on 1/08/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
