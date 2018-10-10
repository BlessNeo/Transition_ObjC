//This is my custom file header.PresentShowCtrl.m,created on 2018/10/10.

#import "PresentShowCtrl.h"
#import "Masonry.h"
#import "BZPresentTransition.h"
#import "BZInteractiveTransition.h"

@interface PresentShowCtrl ()
<
UIViewControllerTransitioningDelegate
>
@property (nonatomic, strong) BZInteractiveTransition *interactiveDismiss;

@end

@implementation PresentShowCtrl

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
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor cyanColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向下滑动 dismiss"
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(dismiss)
     forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.interactiveDismiss =
    [BZInteractiveTransition interactiveTransitionWithType:BZInteractiveTransitionTypeDismiss
                                          gestureDirection:BZInteractiveTransitionGestureDirectionDown];
    [self.interactiveDismiss addPanGestureForViewController:self];
}

- (void)dismiss
{
    if (_delegate && [_delegate respondsToSelector:@selector(presentShowControllerPressedDissmiss)]) {
        [_delegate presentShowControllerPressedDissmiss];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [BZPresentTransition transitionWithType:BZPresentTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [BZPresentTransition transitionWithType:BZPresentTransitionTypeDismiss];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    BZInteractiveTransition *interactivePresent = [_delegate interactiveTransitionForPresent];
    return interactivePresent.interation ? interactivePresent : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return _interactiveDismiss.interation ? _interactiveDismiss : nil;
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
