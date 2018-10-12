//This is my custom file header.CircleSpreadCtrl.m,created on 2018/10/11.

#import "CircleSpreadCtrl.h"
#import "Masonry.h"
#import "CircleSpreadShowCtrl.h"
#import "AppMacro.h"

@interface CircleSpreadCtrl ()

@end

@implementation CircleSpreadCtrl

- (void)dealloc
{
    NSLog(@"这个类%@ destroyed",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = NSLocalizedString(@"小圆点扩散", @"");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    [button setTitle:NSLocalizedString(@"点击或\n拖动我", @"")
            forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = 1;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(present)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    button.layer.cornerRadius = 40;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0)).priorityLow();
        make.size.mas_equalTo(CGSizeMake(80, 80));
        if (@available(iOS 11.0, *)) {
            make.top.greaterThanOrEqualTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.greaterThanOrEqualTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.bottom.right.lessThanOrEqualTo(self.view);
            make.left.greaterThanOrEqualTo(self.view);
            make.top.greaterThanOrEqualTo(self.view);
        }
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pan:)];
    [button addGestureRecognizer:pan];
}

- (CGRect)buttonFrame
{
    // navigationbar translucent 为 NO, UIView 的原点 y 为导航栏 maxY
    // 而动画 [transitionContext containerView] 的原点是(0,0)
    if (@available(iOS 11.0, *)) {
        return CGRectMake(self.button.frame.origin.x,
                          self.button.frame.origin.y + kStatusBarHeight + (self.navigationController.navigationBar.prefersLargeTitles ? kNavigationBarLargeTitleHeight : kNavigationBarHeight),
                          self.button.frame.size.width, self.button.frame.size.height);
    } else {
        return CGRectMake(self.button.frame.origin.x,
                          self.button.frame.origin.y + kStatusBarHeight + kNavigationBarHeight,
                          self.button.frame.size.width, self.button.frame.size.height);
    }
}

- (void)present
{
    CircleSpreadShowCtrl *ctrlShow = [CircleSpreadShowCtrl new];
    [self presentViewController:ctrlShow
                       animated:YES
                     completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)panGesture
{
#warning 待研究
    CGPoint translation = [panGesture translationInView:self.view];
    CGPoint newCenter = CGPointMake(panGesture.view.center.x+ translation.x,
                                    panGesture.view.center.y + translation.y);
    //限制屏幕范围：
    newCenter.y = MAX(panGesture.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.view.frame.size.height - panGesture.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(panGesture.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.view.frame.size.width - panGesture.view.frame.size.width/2,newCenter.x);
    panGesture.view.center = newCenter;
    [panGesture setTranslation:CGPointZero
                        inView:self.view];
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
