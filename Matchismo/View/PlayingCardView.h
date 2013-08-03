//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Scott Rogers on 1/08/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
