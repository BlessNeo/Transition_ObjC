//This is my custom file header.BZCircleSpreadTransition.h,created on 2018/10/11.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BZCircleSpreadTransitionType) {
    BZCircleSpreadTransitionTypePresent = 0,
    BZCircleSpreadTransitionTypeDismiss
};

@interface BZCircleSpreadTransition : NSObject
<
UIViewControllerAnimatedTransitioning
>

@property (nonatomic, assign) BZCircleSpreadTransitionType type;

+ (instancetype)transitionWithType:(BZCircleSpreadTransitionType)type;
- (instancetype)initWithTransitionType:(BZCircleSpreadTransitionType)type;

@end

NS_ASSUME_NONNULL_END
