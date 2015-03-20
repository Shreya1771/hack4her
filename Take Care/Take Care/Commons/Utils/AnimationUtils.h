//
//  AnimationUtils.h
//  Unity-iPhone
//
//  Created by codeegoh on 03/21/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationUtils : NSObject
+ (void)animateShow:(UIView *)view;
+ (void)animateShow:(UIView *)view withDuration:(CFTimeInterval)duration;
+ (void)animateHide:(UIView *)view withCallback:(void (^)())callback;
+ (void)hideTabBar:(UITabBarController *)tabbarcontroller;
+ (void)showTabBar:(UITabBarController *)tabbarcontroller;
@end
