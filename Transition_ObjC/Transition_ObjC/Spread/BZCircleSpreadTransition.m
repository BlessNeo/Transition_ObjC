//This is my custom file header.BZCircleSpreadTransition.m,created on 2018/10/11.

#import "BZCircleSpreadTransition.h"

@implementation BZCircleSpreadTransition

+ (instancetype)transitionWithType:(BZCircleSpreadTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(BZCircleSpreadTransitionType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case BZCircleSpreadTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case BZCircleSpreadTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
            default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.75f;
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

@end
