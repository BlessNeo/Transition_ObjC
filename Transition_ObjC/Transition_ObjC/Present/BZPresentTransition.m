//This is my custom file header.BZPresentTransition.m,created on 2018/10/10.

#import "BZPresentTransition.h"

@interface BZPresentTransition ()
/**
 动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) BZPresentTransitionType type;

@end

@implementation BZPresentTransition

+ (instancetype)transitionWithType:(BZPresentTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(BZPresentTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case BZPresentTransitionTypePresent:
            [self doPresentAnimation:transitionContext];
            break;
        case BZPresentTransitionTypeDismiss:
            [self doDismissAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return _type == BZPresentTransitionTypePresent ? 0.5 : 0.25;
}

- (void)doPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //取到转场过渡动画两个目标容器 A->B
    UIViewController *fromCtrl =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toCtrl =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //snapshotViewAfterScreenUpdates 可以对某个视图截图，我们采用对这个截图做动画代替直接对vc1做动画，因为在手势过渡中直接使用vc1动画会和手势有冲突，如果不需要实现手势的话，就可以不是用截图视图了，大家可以自行尝试一下
    UIView *tempView = [fromCtrl.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromCtrl.view.frame;
    //因为对截图做动画，fromCtrl 就可以隐藏了
    fromCtrl.view.hidden = YES;
    //这里有个重要的概念 containerView，如果要对视图做转场动画，视图就必须要加入 containerView中才能进行，可以理解 containerView 管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和 toCtrl 的 view 都加入 containerView 中,注意顺序
    [containerView addSubview:tempView];
    [containerView addSubview:toCtrl.view];
    //设置 toCtrl 的 frame，因为这里 toCtrl present 出来不是全屏，且初始的时候在底部，如果不设置 frame 的话默认就是整个屏幕咯，这里 containerView 的 frame 就是整个屏幕
    toCtrl.view.frame = CGRectMake(0, containerView.bounds.size.height,
                                   containerView.bounds.size.width, 400);
    //使用系统的弹性动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.55
          initialSpringVelocity:1 / 0.55
                        options:0
                     animations:^{
                         //首先我们让 toCtrl 向上移动
                         toCtrl.view.transform = CGAffineTransformMakeTranslation(0, -400);
                         //然后让截图视图缩小一点即可
                         tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                         
    } completion:^(BOOL finished) {
        //使用如下代码标记整个转场过程是否正常完成 [transitionContext transitionWasCancelled] 代表手势是否取消了，如果取消了就传 NO 表示转场失败，反之亦然，如果不是用手势的话直接传 YES 也是可以的，我们必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在，会出现无法交互的情况，切记
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromCtrl.view.hidden = NO;
            //然后移除截图视图，因为下次触发present会重新截图
            [tempView removeFromSuperview];
        }
    }];
}

- (void)doDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //B->A 反过来了
    UIViewController *fromCtrl =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toCtrl =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //参照 present 动画的逻辑，present 成功后，containerView 的最后一个子视图就是截图视图，我们将其取出准备动画
    UIView *containerView = [transitionContext containerView];
    NSArray *subviewsArray = containerView.subviews;
    UIView *tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    //动画吧
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为 present 的时候都是使用的 transform，这里的动画只需要将 transform 恢复就可以了
        fromCtrl.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了接标记失败
            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            toCtrl.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
