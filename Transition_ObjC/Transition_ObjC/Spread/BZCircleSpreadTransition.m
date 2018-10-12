//This is my custom file header.BZCircleSpreadTransition.m,created on 2018/10/11.

#import "BZCircleSpreadTransition.h"
#import "CircleSpreadCtrl.h"

@interface BZCircleSpreadTransition ()
<
CAAnimationDelegate
>
@end

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

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromCtrl =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toCtrl =
    (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CircleSpreadCtrl *temp = toCtrl.viewControllers.lastObject;
    UIView *containerView = [transitionContext containerView];
    //画两个圆路径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:temp.buttonFrame];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromCtrl.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toCtrl =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *fromCtrl =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CircleSpreadCtrl *tempCtrl = fromCtrl.viewControllers.lastObject;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toCtrl.view];
    //动画
    //画两个圆路径
    //第一个按钮区域的内切椭圆
    UIBezierPath *startCircle =
    [UIBezierPath bezierPathWithOvalInRect:tempCtrl.buttonFrame];
    //第二个圆 能够完全包含 containerView 的最小圆
    //圆心
    CGFloat x = MAX(tempCtrl.buttonFrame.origin.x, containerView.frame.size.width - tempCtrl.buttonFrame.origin.x);
    CGFloat y = MAX(tempCtrl.buttonFrame.origin.y, containerView.frame.size.height - tempCtrl.buttonFrame.origin.y);
    //最小半径
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *endCircle =
    [UIBezierPath bezierPathWithArcCenter:containerView.center
                                   radius:radius
                               startAngle:0
                                 endAngle:M_PI * 2
                                clockwise:YES];
    //创建 CAShapeLayer 进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCircle.CGPath;
    //将 maskLayer 作为 toCtrl.View 的遮盖
    toCtrl.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //动画是加到 layer 上的，所以必须为 CGPath，再将 CGPath 桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startCircle.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(endCircle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayerAnimation setValue:transitionContext
                          forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation
                     forKey:@"path"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
    switch (_type) {
        case BZCircleSpreadTransitionTypePresent:
        {
            id <UIViewControllerContextTransitioning> transitionContext =
            [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
        }
            break;
        case BZCircleSpreadTransitionTypeDismiss:
        {
            id <UIViewControllerContextTransitioning> transitionContext =
            [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
