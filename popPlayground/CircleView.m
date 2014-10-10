//
//  CircleView.m
//  popPlayground
//
//  Created by Edwin Aaron Saenz on 10/3/14.
//  Copyright (c) 2014 Edwin Aaron Saenz. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
    [circle addClip];
    
    [[UIColor redColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [circle fill];
}

- (void) awakeFromNib
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

@end
