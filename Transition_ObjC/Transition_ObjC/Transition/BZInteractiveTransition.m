//This is my custom file header.BZInteractiveTransition.m,created on 2018/10/9.

#import "BZInteractiveTransition.h"

@interface BZInteractiveTransition()
//如果把 weak 改为 strong 将导致 ctrl 无法 dealloc,当 pop 到前面页面时 APP crash 掉
#warning 要搞明白
@property (nonatomic, weak) UIViewController *ctrl;
///手势方向
@property (nonatomic, assign) BZInteractiveTransitionGestureDirection direction;
///过渡转场(手势)类型
@property (nonatomic, assign) BZInteractiveTransitionType type;

@end

@implementation BZInteractiveTransition

+ (instancetype)interactiveTransitionWithType:(BZInteractiveTransitionType)type
                             gestureDirection:(BZInteractiveTransitionGestureDirection)direction
{
    return [[self alloc] initWithInteractiveTransitionType:type
                                          gestureDirection:direction];
}

- (instancetype)initWithInteractiveTransitionType:(BZInteractiveTransitionType)type
                                 gestureDirection:(BZInteractiveTransitionGestureDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController
{
    self.ctrl = viewController;
    UIPanGestureRecognizer *pan =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleGesture:)];
    [viewController.view addGestureRecognizer:pan];
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    //手势百分比
    CGFloat percent = 0.f;
    switch (_direction) {
        case BZInteractiveTransitionGestureDirectionLeft:
            {
                CGFloat transitionX = - [panGesture translationInView:panGesture.view].x;
                percent = transitionX / panGesture.view.frame.size.width;
            }
            break;
        case BZInteractiveTransitionGestureDirectionRight:
        {
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case BZInteractiveTransitionGestureDirectionUp:
        {
            CGFloat transitionY = - [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.height;
        }
            break;
        case BZInteractiveTransitionGestureDirectionDown:
        {
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            //手势过程中，通过 updateInteractiveTransition 设置 pop 过程进行的百分比
            [self updateInteractiveTransition:percent];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            //手势完成后结束标记并且判断移动距离是否达到要求，过则 finishInteractiveTransition 完成转场操作
            //否则取消转场操作
            self.interation = NO;
            if (percent > 0.15) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)startGesture
{
    switch (_type) {
        case BZInteractiveTransitionTypePresent:
        {
            if (_configPresent) {
                _configPresent();
            }
        }
            break;
        case BZInteractiveTransitionTypeDismiss:
        {
            [_ctrl dismissViewControllerAnimated:YES
                                      completion:nil];
        }
            break;
        case BZInteractiveTransitionTypePush:
        {
            if (_configPush) {
                _configPush();
            }
        }
            break;
        case BZInteractiveTransitionTypePop:
        {
            [_ctrl.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
