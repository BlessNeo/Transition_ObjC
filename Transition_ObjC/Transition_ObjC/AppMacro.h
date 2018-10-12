
//This is my custom file header.AppMacro.h,created on 2018/10/12.

#ifndef AppMacro_h
#define AppMacro_h

/// 状态栏高度 iPhoneX 44.0f 非 iPhoneX 20.f
#define kStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
/// 普通导航栏高度 44.0f
#define kNavigationBarHeight 44.0f
/// 大标题导航栏高度 96.0f
#define kNavigationBarLargeTitleHeight 96.0f
/// TabBar 高度
#define kTabBarHeight CGRectGetHeight(kAppDelegate.tabBarCtrl.tabBar.frame)


#endif /* AppMacro_h */
