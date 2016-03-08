//
//  TestView.m
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/14/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import "TestView.h"

@implementation TestView
{
    UIBezierPath *path; // (3)
}

//- (id)initWithCoder:(NSCoder *)aDecoder // (1)
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        [self setMultipleTouchEnabled:NO]; // (2)
//        [self setBackgroundColor:[UIColor whiteColor]];
//        path = [UIBezierPath bezierPath];
//        [path setLineWidth:2.0];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setMultipleTouchEnabled:NO]; // (2)
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2.0];
    return self;
}

- (void)drawRect:(CGRect)rect // (5)
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p]; // (4)
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
@end
