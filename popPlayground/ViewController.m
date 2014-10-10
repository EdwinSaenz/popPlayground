//
//  ViewController.m
//  popPlayground
//
//  Created by Edwin Aaron Saenz on 10/3/14.
//  Copyright (c) 2014 Edwin Aaron Saenz. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import <pop/POP.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet CircleView *redCircle;
@property BOOL switcher;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCirclePanRecognition];
    [self setSingleTapRecognition];
    self.switcher = true;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = self.switcher
        ? [NSValue valueWithCGRect:CGRectMake(0, 0, 400, 400)]
        : [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
    
    self.switcher = !self.switcher;
    [self.redCircle pop_addAnimation:anim forKey:@"anim"];
}

CGFloat firstX = 0;
CGFloat firstY = 0;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    self.redCircle.center = [recognizer locationInView:self.backgroundView];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        [self.redCircle pop_removeAllAnimations];
        
        firstX = [[recognizer view] center].x;
        firstY = [[recognizer view] center].y;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
        CGFloat velocityX = (0.5*[recognizer velocityInView:self.view].x);
        CGFloat velocityY = (0.5*[recognizer velocityInView:self.view].y);
        
        POPDecayAnimation *animX = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        POPDecayAnimation *animY = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        
        animX.fromValue = [NSNumber numberWithFloat:translatedPoint.x];
        animY.fromValue = [NSNumber numberWithFloat:translatedPoint.y];
        
        animX.velocity = [NSNumber numberWithFloat:velocityX];
        animY.velocity = [NSNumber numberWithFloat:velocityY];
        
        [self.redCircle pop_addAnimation:animX forKey:@"animX"];
        [self.redCircle pop_addAnimation:animY forKey:@"animY"];
    }
}

- (void)setCirclePanRecognition {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [recognizer setMaximumNumberOfTouches:1];
    [recognizer setMinimumNumberOfTouches:1];
    [self.redCircle addGestureRecognizer:recognizer];
}

- (void)setSingleTapRecognition {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.redCircle addGestureRecognizer:singleTap];
}

@end
