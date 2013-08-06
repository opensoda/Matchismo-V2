//
//  SetCardView.m
//  Matchismo
//
//  Created by Scott Rogers on 5/08/13.
//  Copyright (c) 2013 opensoda. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setNumber:(int)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(int)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(int)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(int)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:12.0];
    [roundedRect addClip];
    
    if (self.faceUp) {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols {
    CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    
    switch (self.number) {
        case 1:
            [self drawSymbolAtPoint:point];
            break;
        case 2:
            [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2, point.y)];
            [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2, point.y)];
            break;
        case 3:
            [self drawSymbolAtPoint:point];
            [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
            [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
            break;
        default:
            break;
    }
}

- (UIColor *)uiColor {
    
    UIColor *color = nil;
    
    switch (self.color) {
        case 1:
            color = [UIColor redColor];
            break;
        case 2:
            color = [UIColor blueColor];
            break;
        case 3:
            color = [UIColor greenColor];
            break;
        default:
            break;
    }

    return color;
}

- (void)drawSymbolAtPoint:(CGPoint)point {
    
    switch (self.symbol) {
        case 1:
            [self drawOvalAtPoint:point];
            break;
        case 2:
            [self drawSquiggleAtPoint:point];
            break;
        case 3:
            [self drawDiamondAtPoint:point];
            break;
        default:
            break;
    }
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point {
    
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2 * dx, 2 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self drawPath:path];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point {
    
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self drawPath:path];
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point {
    
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self drawPath:path];
}

- (void)drawPath:(UIBezierPath *)path {
    
    switch (self.shading) {
        case 1: // solid
            [[self uiColor] setFill];
            [[self uiColor] setStroke];
            break;
        case 2: // shaded 
            [[[self uiColor] colorWithAlphaComponent:0.3f] setFill];
            [[[self uiColor]  colorWithAlphaComponent:0.3f] setStroke];
            break;
        case 3: // open
            [[UIColor clearColor] setFill];
            [[self uiColor] setStroke];
            break;
        default:
            break;
    }
    [path fill];
    [path stroke];
}


@end
