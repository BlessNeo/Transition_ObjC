//This is my custom file header.MagicMoveDetailCtrl.m,created on 2018/10/9.

#import "MagicMoveDetailCtrl.h"
#import "MagicMoveTransition.h"
#import "Masonry.h"
#import "BZInteractiveTransition.h"

@interface MagicMoveDetailCtrl ()
///手势交互
@property (nonatomic, strong) BZInteractiveTransition *interfaceTransition;

@end

@implementation MagicMoveDetailCtrl

- (void)dealloc
{
    NSLog(@"这个类%@ destroyed",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"详情", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    self.imgViewDetail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_list"]];
    [self.view addSubview:self.imgViewDetail];
    [self.imgViewDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.left.and.right.and.top.equalTo(self.view);
        }
        make.height.equalTo(self.imgViewDetail.mas_width).multipliedBy(1);
    }];
    //初始化手势交互代理
    self.interfaceTransition =
    [BZInteractiveTransition interactiveTransitionWithType:BZInteractiveTransitionTypePop
                                          gestureDirection:BZInteractiveTransitionGestureDirectionRight];
    //给当前控制器的视图添加手势
    [_interfaceTransition addPanGestureForViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    NSLog(@"%@",NSStringFromCGRect(self.imgViewDetail.frame));
    //区分是 push 还是 pop,返回动画过渡代理做相应的动画操作
    return [MagicMoveTransition transitionWithType:operation == UINavigationControllerOperationPush ? MagicMoveTransitionTypePush : MagicMoveTransitionTypePop];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return _interfaceTransition.interation ? _interfaceTransition : nil;
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
