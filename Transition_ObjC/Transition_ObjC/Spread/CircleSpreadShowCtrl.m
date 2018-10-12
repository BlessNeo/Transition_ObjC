//This is my custom file header.CircleSpreadShowCtrl.m,created on 2018/10/11.

#import "CircleSpreadShowCtrl.h"
#import "BZCircleSpreadTransition.h"
#import "BZInteractiveTransition.h"

@interface CircleSpreadShowCtrl ()
<
UIViewControllerTransitioningDelegate
>
@property (nonatomic, strong) BZInteractiveTransition *interactiveTransition;

@end

@implementation CircleSpreadShowCtrl

- (void)dealloc
{
    NSLog(@"这个类%@ destroyed",NSStringFromClass([self class]));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"点我或向下滑动 dismiss", @"")
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(dismiss)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    button.frame = CGRectMake(0, self.view.frame.size.height - 200,
                              self.view.frame.size.width, 50);
    [self.view addSubview:button];
    //手势交互
    self.interactiveTransition =
    [BZInteractiveTransition interactiveTransitionWithType:BZInteractiveTransitionTypeDismiss
                                          gestureDirection:BZInteractiveTransitionGestureDirectionDown];
    [self.interactiveTransition addPanGestureForViewController:self];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [BZCircleSpreadTransition transitionWithType:BZCircleSpreadTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [BZCircleSpreadTransition transitionWithType:BZCircleSpreadTransitionTypeDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _interactiveTransition.interation ? _interactiveTransition : nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
