//This is my custom file header.MagicMoveTransition.m,created on 2018/10/9.

#import "MagicMoveTransition.h"
#import "MagicMoveListCell.h"
#import "MagicMoveListCtrl.h"
#import "MagicMoveDetailCtrl.h"

@interface MagicMoveTransition()

/**
 动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) MagicMoveTransitionType type;

@end

@implementation MagicMoveTransition

+ (instancetype)transitionWithType:(MagicMoveTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(MagicMoveTransitionType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

// 两个必须要实现的代理方法
// 动画的具体实现
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case MagicMoveTransitionTypePush:
            [self doPushAnimation:transitionContext];
            break;
        case MagicMoveTransitionTypePop:
            [self doPopAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}

// 动画时长
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.75f;
}

- (void)doPushAnimation:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
#warning 如果把 UINavigationController 的 UINavigationBar 的 translucent 设为 YES,过渡动画有问题，动画进行中会有 44px 的偏差，动画完成后会恢复正常，待 fix,暂时的解决方案是把 translucent 设为 NO
    MagicMoveListCtrl *fromCtrl =
    (MagicMoveListCtrl *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MagicMoveDetailCtrl *toCtrl =
    (MagicMoveDetailCtrl *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //如果 toCtrl 用到了 Masonry 等类似的 layout 布局约束，一定要调用一次 layoutIfNeeded
    //[toCtrl.view layoutIfNeeded];
    [toCtrl.imgViewDetail.superview layoutIfNeeded];
    //拿到当前点击的 cell 的 imageview
    MagicMoveListCell *cell =
    (MagicMoveListCell *)[fromCtrl.collectionView cellForItemAtIndexPath:fromCtrl.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡
    UIView *tempView = [cell.imgViewList snapshotViewAfterScreenUpdates:NO];
    //并将视图转换到当前控制器的坐标
    tempView.frame = [cell.imgViewList convertRect:cell.imgViewList.frame
                                            toView:containerView];
    //设置动画前的各个控件的状态
    cell.imgViewList.hidden = YES;
    toCtrl.view.alpha = 0;
    toCtrl.imgViewDetail.hidden = YES;
    //tempView 添加到 containnerView，要保证在最前方，所以后添加
    [containerView addSubview:toCtrl.view];
    [containerView addSubview:tempView];
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.55
          initialSpringVelocity:1 / 0.55
                        options:0
                     animations:^{
                         tempView.frame = [toCtrl.imgViewDetail convertRect:toCtrl.imgViewDetail.frame
                                                                     toView:containerView];
                         toCtrl.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toCtrl.imgViewDetail.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，
        //如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}

- (void)doPopAnimation:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    MagicMoveDetailCtrl *fromCtrl =
    (MagicMoveDetailCtrl *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MagicMoveListCtrl *toCtrl =
    (MagicMoveListCtrl *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到当前点击的 cell 的 imageview
    MagicMoveListCell *cell =
    (MagicMoveListCell *)[toCtrl.collectionView cellForItemAtIndexPath:toCtrl.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //这里的 tempView 就是 push 时候初始化的那个 tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置动画前的各个控件的状态
    cell.imgViewList.hidden = YES;
    fromCtrl.imgViewDetail.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toCtrl.view
                         atIndex:0];
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.55
          initialSpringVelocity:1 / 0.55
                        options:0
                     animations:^{
                         tempView.frame = [cell.imgViewList convertRect:cell.imgViewList.frame
                                                                 toView:containerView];
                         fromCtrl.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         //由于加入了手势必须判断
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         if ([transitionContext transitionWasCancelled]) {
                             //手势取消了，原来隐藏的 imageview 要显示出来
                             //失败了隐藏 tempView，显示 fromCtrl.imgViewDetail
                             tempView.hidden = YES;
                             fromCtrl.imgViewDetail.hidden = NO;
                         } else {
                             //手势成功，cell 的 imageview 也要显示出来
                             //成功了移除 tempView，下一次 push 的时候又要创建
                             //cell 的 imageview 要显示出来
                             cell.imgViewList.hidden = NO;
                             [tempView removeFromSuperview];
                         }
                     }];
}

@end
