//This is my custom file header.MagicMoveTransition.h,created on 2018/10/9.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 动画过渡代理管理类型

 - MagicMoveTransitionTypePush: push
 - MagicMoveTransitionTypePop: pop
 */
typedef NS_ENUM(NSUInteger, MagicMoveTransitionType) {
    MagicMoveTransitionTypePush = 0,
    MagicMoveTransitionTypePop
};

@interface MagicMoveTransition : NSObject
<
UIViewControllerAnimatedTransitioning
>

/**
 初始化动画过渡代理

 @param type 过渡类型
 @return self
 */
+ (instancetype)transitionWithType:(MagicMoveTransitionType)type;

/**
 初始化动画过渡代理

 @param type  过渡类型
 @return self
 */
- (instancetype)initWithTransitionType:(MagicMoveTransitionType)type;

@end
