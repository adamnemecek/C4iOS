//
//  C4Layer.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Layer.h"

@interface C4Layer ()
@property (readwrite, nonatomic) CGFloat rotationAngle, rotationAngleX, rotationAngleY;
@end

@implementation C4Layer
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount, animationDuration = _animationDuration;
@synthesize allowsInteraction, repeats;
@synthesize rotationAngle, rotationAngleX, rotationAngleY;
@synthesize perspectiveDistance;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.name = @"backingLayer";
        self.repeatCount = 0;
        self.autoreverses = NO;
        self.rotationAngle = 0;
        currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        allowsInteraction = NO;
        repeats = NO;
        
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
#ifdef VERBOSE
        C4Log(@"%@ init",[self class]);
#endif
    }
    return self;
}

-(void)awakeFromNib {
#ifdef VERBOSE
    C4Log(@"%@ awakeFromNib",[self class]);
#endif
}

#pragma mark Safe Initialization Methods
-(void)setup {
    
}

#pragma mark C4Layer Animation Methods
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = self.animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:self.currentAnimationEasing];
    animation.autoreverses = self.autoreverses;
    animation.repeatCount = self.repeats ? FOREVER : 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    return animation;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    if((animationOptions & LINEAR) == LINEAR) {
        currentAnimationEasing = kCAMediaTimingFunctionLinear;
    } else if((animationOptions & EASEOUT) == EASEOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
    } else if((animationOptions & EASEIN) == EASEIN) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
    } else if((animationOptions & EASEINOUT) == EASEINOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    } else {
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
    }
    
    if((animationOptions & AUTOREVERSE) == AUTOREVERSE) self.autoreverses = YES;
    else self.autoreverses = NO;
    
    if((animationOptions & REPEAT) == REPEAT) repeats = YES;
    else repeats = NO;
    
    if((animationOptions & ALLOWSINTERACTION) == ALLOWSINTERACTION) allowsInteraction = YES;
    else allowsInteraction = NO;
}

#pragma mark C4Layer methods
-(void)animateShadowColor:(CGColorRef)_shadowColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowColor"];
    animation.fromValue = (id)self.shadowColor;
    animation.toValue = (__bridge id)_shadowColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.shadowColor = _shadowColor; 
            [self removeAnimationForKey:@"animateShadowColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowColor"];
    [CATransaction commit];
}

-(void)animateShadowOpacity:(CGFloat)_shadowOpacity {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowOpacity];
    animation.toValue = [NSNumber numberWithFloat:_shadowOpacity];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.shadowOpacity = _shadowOpacity; 
            [self removeAnimationForKey:@"animateShadowOpacity"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
    [CATransaction commit];
}

-(void)animateShadowRadius:(CGFloat)_shadowRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowRadius"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowRadius];
    animation.toValue = [NSNumber numberWithFloat:_shadowRadius];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.shadowRadius = _shadowRadius; 
            [self removeAnimationForKey:@"animateShadowRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowRadius"];
    [CATransaction commit];
}

-(void)animateShadowOffset:(CGSize)_shadowOffset {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOffset"];
    animation.fromValue = [NSValue valueWithCGSize:self.shadowOffset];
    animation.toValue = [NSValue valueWithCGSize:_shadowOffset];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.shadowOffset = _shadowOffset; 
            [self removeAnimationForKey:@"animateShadowOffset"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOffset"];
    [CATransaction commit];
}

-(void)animateShadowPath:(CGPathRef)_shadowPath {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)self.shadowPath;
    animation.toValue = (__bridge id)_shadowPath;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.shadowPath = _shadowPath;
            [self removeAnimationForKey:@"animateShadowPath"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowPath"];
    [CATransaction commit];
}

-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundFilters"];
    animation.fromValue = self.backgroundFilters;
    animation.toValue = _backgroundFilters;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.backgroundFilters = _backgroundFilters; 
            [self removeAnimationForKey:@"animateBackgroundFilters"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundFilters"];
    [CATransaction commit];
}

-(void)animateCompositingFilter:(id)_compositingFilter {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"compositingFilter"];
    animation.fromValue = self.compositingFilter;
    animation.toValue = _compositingFilter;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.compositingFilter = _compositingFilter; 
            [self removeAnimationForKey:@"animateCompositingFilter"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
    [CATransaction commit];
}

-(void)animateContents:(CGImageRef)_image {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"contents"];
    animation.fromValue = self.contents;
    animation.toValue = (__bridge id)_image;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.contents = (__bridge id)_image; 
            [self removeAnimationForKey:@"animateContents"];
        }];
    }
    [self addAnimation:animation forKey:@"animateContents"];
    [CATransaction commit];
}
/* in the following method
 if we implement other kinds of options, we'll have to get rid of the returns...
 reversing how i check the values, if linear is at the bottom, then all the other values get called
 */

-(void)test {
    C4Log(@"animationOptions: %@",self.currentAnimationEasing);
    C4Log(@"autoreverses: %@", self.autoreverses ? @"YES" : @"NO");
}

//-(BOOL)isOpaque {
//    /*
//     Apple docs say that the frameworks flip this to NO automatically 
//     ...if you do things like set the background color to anything transparent (i.e. alpha other than 1.0f)
//     */
//    return YES;
//}

#pragma mark New Stuff
-(void)animateBackgroundColor:(CGColorRef)_backgroundColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (id)self.backgroundColor;
    animation.toValue = (__bridge id)_backgroundColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.backgroundColor = _backgroundColor; 
            [self removeAnimationForKey:@"animateBackgroundColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundColor"];
    [CATransaction commit];
}

-(void)animateBorderWidth:(CGFloat)_borderWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderWidth"];
    animation.fromValue = [NSNumber numberWithFloat:self.borderWidth];
    animation.toValue = [NSNumber numberWithFloat:_borderWidth];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.borderWidth = _borderWidth; 
            [self removeAnimationForKey:@"animateBorderWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderWidth"];
    [CATransaction commit];
}

-(void)animateBorderColor:(CGColorRef)_borderColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderColor"];
    animation.fromValue = (id)self.borderColor;
    animation.toValue = (__bridge id)_borderColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.borderColor = _borderColor; 
            [self removeAnimationForKey:@"animateBorderColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderColor"];
    [CATransaction commit];
}

-(void)animateCornerRadius:(CGFloat)_cornerRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"cornerRadius"];
    animation.fromValue = [NSNumber numberWithFloat:self.cornerRadius];
    animation.toValue = [NSNumber numberWithFloat:_cornerRadius];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.cornerRadius = _cornerRadius; 
            [self removeAnimationForKey:@"animateCornerRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCornerRadius"];
    [CATransaction commit];
}

-(void)animateZPosition:(CGFloat)_zPosition {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"zPosition"];
    animation.fromValue = [NSNumber numberWithFloat:self.zPosition];
    animation.toValue = [NSNumber numberWithFloat:_zPosition];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.zPosition = _zPosition; 
            [self removeAnimationForKey:@"animateZPosition"];
        }];
    }
    [self addAnimation:animation forKey:@"animateZPosition"];
    [CATransaction commit];
}

-(void)animateRotation:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngle];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.rotationAngle = _rotationAngle; 
            ((C4Control *)self.delegate).transform = CGAffineTransformMakeRotation(self.rotationAngle);
            [self removeAnimationForKey:@"animateTransform.rotation.z"];
        }];
    }
    [self addAnimation:animation forKey:@"animateTransform.rotation.z"];
    [CATransaction commit];
}

-(void)animateRotationX:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CATransform3D t = self.transform;
    t.m34 = self.perspectiveDistance;
    self.transform = t;
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.x"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngleX];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.rotationAngleX = _rotationAngle; 
            [self removeAnimationForKey:@"animateRotation"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotation"];
    [CATransaction commit];
}

-(void)animateRotationY:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CATransform3D t = self.transform;
    t.m34 = self.perspectiveDistance;
    self.transform = t;
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngleY];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.rotationAngleY = _rotationAngle; 
            [self removeAnimationForKey:@"animateRotation"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotation"];
    [CATransaction commit];
}

-(void)animateLayerTransform:(CATransform3D)_transform {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"sublayerTransform"];
    animation.fromValue = [NSValue valueWithCATransform3D:self.sublayerTransform];
    animation.toValue = [NSValue valueWithCATransform3D:_transform];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.sublayerTransform = _transform; 
            [self removeAnimationForKey:@"sublayerTransform"];
        }];
    }
    [self addAnimation:animation forKey:@"sublayerTransform"];
    [CATransaction commit];
}

@end
