//This is my custom file header.CircleSpreadShowCtrl.m,created on 2018/10/11.

#import "CircleSpreadShowCtrl.h"

@interface CircleSpreadShowCtrl ()

@end

@implementation CircleSpreadShowCtrl

- (void)dealloc
{
    NSLog(@"这个类%@ destroyed",NSStringFromClass([self class]));
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
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
