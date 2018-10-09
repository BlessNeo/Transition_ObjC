//This is my custom file header.BZInteractiveTransition.h,created on 2018/10/9.

#import <UIKit/UIKit.h>

typedef void(^GestureConfig)(void);

/**
 手势交互方向

 - BZInteractiveTransitionGestureDirectionLeft: 左
 - BZInteractiveTransitionGestureDirectionRight: 右
 - BZInteractiveTransitionGestureDirectionUp: 上
 - BZInteractiveTransitionGestureDirectionDown: 下
 */
typedef NS_ENUM(NSUInteger, BZInteractiveTransitionGestureDirection) {
    BZInteractiveTransitionGestureDirectionLeft = 0,
    BZInteractiveTransitionGestureDirectionRight,
    BZInteractiveTransitionGestureDirectionUp,
    BZInteractiveTransitionGestureDirectionDown
};

/**
 手势交互过渡类型

 - BZInteractiveTransitionTypePush: push
 - BZInteractiveTransitionTypePop: pop
 - BZInteractiveTransitionTypePresent: present
 - BZInteractiveTransitionTypeDismiss: dismiss
 */
typedef NS_ENUM(NSUInteger, BZInteractiveTransitionType) {
    BZInteractiveTransitionTypePush = 0,
    BZInteractiveTransitionTypePop,
    BZInteractiveTransitionTypePresent,
    BZInteractiveTransitionTypeDismiss
};

@interface BZInteractiveTransition : UIPercentDrivenInteractiveTransition
///记录是否开始手势，判断pop操作是手势触发还是返回键触发
@property (nonatomic, assign) BOOL interation;
///触发手势 present 的时候的 config，config 中初始化并 present 需要弹出的控制器
@property (nonatomic, copy) GestureConfig configPresent;
///触发手势 push 的时候的 config，config 中初始化并 push 需要弹出的控制器
@property (nonatomic, copy) GestureConfig configPush;

/**
 初始化方法

 @param type 过渡类型
 @param direction 触发手势方向
 @return self
 */
+ (instancetype)interactiveTransitionWithType:(BZInteractiveTransitionType)type
                             gestureDirection:(BZInteractiveTransitionGestureDirection)direction;

/**
 初始化方法

 @param type 过渡类型
 @param direction 触发手势方向
 @return self
 */
- (instancetype)initWithInteractiveTransitionType:(BZInteractiveTransitionType)type
                                 gestureDirection:(BZInteractiveTransitionGestureDirection)direction;

/**
 给传入的控制器添加手势

 @param viewController 目标控制器
 */
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
