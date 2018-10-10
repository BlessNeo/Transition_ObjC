//This is my custom file header.PresentShowCtrl.h,created on 2018/10/10.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PresentShowCtrlDelegate <NSObject>

- (void)presentShowControllerPressedDissmiss;
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end

@interface PresentShowCtrl : UIViewController
@property (nonatomic, weak) id<PresentShowCtrlDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
