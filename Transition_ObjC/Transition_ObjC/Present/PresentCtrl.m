//This is my custom file header.PresentCtrl.m,created on 2018/10/10.

#import "PresentCtrl.h"
#import "Masonry.h"
#import "PresentShowCtrl.h"
#import "BZInteractiveTransition.h"

@interface PresentCtrl ()
<
PresentShowCtrlDelegate
>
@property (nonatomic, strong) BZInteractiveTransition *interactivePresent;

@end

@implementation PresentCtrl

- (void)dealloc
{
    NSLog(@"这个类%@ destroyed",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.layer.cornerRadius = 10;
    self.navigationController.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"弹性 Pop", @"");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_present"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(20);
        }
        make.size.mas_equalTo(CGSizeMake(250, 250));
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或者向上滑动 present"
            forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(30);
    }];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(present)
     forControlEvents:UIControlEventTouchUpInside];
    _interactivePresent =
    [BZInteractiveTransition interactiveTransitionWithType:BZInteractiveTransitionTypePresent
                                          gestureDirection:BZInteractiveTransitionGestureDirectionUp];
    __weak typeof (self) weakSelf = self;
    _interactivePresent.configPresent = ^(){
        [weakSelf present];
    };
    [_interactivePresent addPanGestureForViewController:self.navigationController];
}

- (void)present
{
    PresentShowCtrl *ctrlShow = [PresentShowCtrl new];
    ctrlShow.delegate = self;
    [self presentViewController:ctrlShow
                       animated:YES
                     completion:nil];
}

- (void)presentShowControllerPressedDissmiss{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent
{
    return _interactivePresent;
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
