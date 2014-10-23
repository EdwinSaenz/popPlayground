//
//  DecayViewController.m
//  popPlayground
//
//  Created by Edwin Aaron Saenz on 10/16/14.
//  Copyright (c) 2014 Edwin Aaron Saenz. All rights reserved.
//

#import "DecayViewController.h"
#import <POP/POP.h>

@interface DecayViewController () <POPAnimationDelegate>
@property(nonatomic) UIControl *dragView;
@property(nonatomic) UIDynamicAnimator *animator;
@property(nonatomic) UIGravityBehavior *gravity;
@property(nonatomic) UICollisionBehavior *collision;
@property(nonatomic) UIDynamicItemBehavior *behavior;
- (void)addDragView;
- (void)touchDown:(UIControl *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
@end

@implementation DecayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self addDragView];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dragView]];
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.dragView]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dragView]];
    self.behavior.elasticity = 1.0;
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidApply:(POPDecayAnimation *)anim {
    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, self.dragView.frame);
    if(isDragViewOutsideOfSuperView) {
        long viewWidth = self.view.frame.size.width;
        long viewHeight = self.view.frame.size.height;
        CGPoint leftEdge = CGPointMake(self.dragView.center.x - 50, self.dragView.center.y);
        CGPoint upperEdge = CGPointMake(self.dragView.center.x, self.dragView.center.y - 50);
        CGPoint rightEdge = CGPointMake(self.dragView.center.x + 50, self.dragView.center.y);
        CGPoint lowerEdge = CGPointMake(self.dragView.center.x, self.dragView.center.y + 50);
        //
        [self.dragView.layer pop_removeAllAnimations];
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        POPDecayAnimation *newAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        if(rightEdge.x > viewWidth) {
            CGPoint velocity = CGPointMake(-currentVelocity.x, currentVelocity.y);
            newAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            self.dragView.center = CGPointMake(viewWidth - (self.dragView.frame.size.width / 2), self.dragView.center.y);
        }
        else if(leftEdge.x < 0) {
            CGPoint velocity = CGPointMake(-currentVelocity.x, currentVelocity.y);
            newAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            self.dragView.center = CGPointMake(self.dragView.frame.size.width / 2, self.dragView.center.y);
        }
        
        if(lowerEdge.y > viewHeight) {
            CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
            newAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            self.dragView.center = CGPointMake(self.dragView.center.x, viewHeight - (self.dragView.frame.size.height / 2));
        }
        else if(upperEdge.y < 0) {
            CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
            newAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            self.dragView.center = CGPointMake(self.dragView.center.x, self.dragView.frame.size.height / 2);
        }
        
        newAnimation.delegate = self;
        [self.dragView.layer pop_addAnimation:newAnimation forKey:@"layerPositionAnimation"];
    }
}

#pragma mark - Private instance methods

- (void)addDragView {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTouchesRequired:2];
    self.dragView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.dragView.center = self.view.center;
    self.dragView.layer.cornerRadius = CGRectGetWidth(self.dragView.bounds) / 2;
    self.dragView.backgroundColor = [UIColor redColor];
    [self.dragView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.dragView addGestureRecognizer:recognizer];
    [self.dragView addGestureRecognizer:tapRecognizer];
    //
    [self.view addSubview:self.dragView];
}

- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
    [self.animator removeAllBehaviors];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.behavior];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    //
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}

@end
