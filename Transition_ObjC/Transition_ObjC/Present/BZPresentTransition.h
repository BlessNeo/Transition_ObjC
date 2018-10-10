//This is my custom file header.BZPresentTransition.h,created on 2018/10/10.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 模态类型

 - BZPresentTransitionTypePresent: present
 - BZPresentTransitionTypeDismiss: dismiss
 */
typedef NS_ENUM(NSUInteger, BZPresentTransitionType) {
    BZPresentTransitionTypePresent = 0,
    BZPresentTransitionTypeDismiss
};

@interface BZPresentTransition : NSObject
<
UIViewControllerAnimatedTransitioning
>

/**
 初始化动画过渡代理
 
 @param type 过渡类型
 @return self
 */
+ (instancetype)transitionWithType:(BZPresentTransitionType)type;

/**
 初始化动画过渡代理
 
 @param type  过渡类型
 @return self
 */
- (instancetype)initWithTransitionType:(BZPresentTransitionType)type;

@end

NS_ASSUME_NONNULL_END
