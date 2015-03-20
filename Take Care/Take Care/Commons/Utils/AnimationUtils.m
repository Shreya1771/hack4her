//
//  AnimationUtils.m
//  Unity-iPhone
//
//  Created by codeegoh on 03/21/15.
//
//

#import "AnimationUtils.h"

@implementation AnimationUtils


#pragma mark - Animate Control View
+ (void)animateShow:(UIView *)view
{
    [self animateShow:view withDuration:0.2];
}

+ (void)animateShow:(UIView *)view withDuration:(CFTimeInterval)duration
{
    view.hidden = NO;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    
    [view.layer addAnimation:animation forKey:@"show"];
}

+ (void)animateHide:(UIView *)view withCallback:(void (^)())callback
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.1;
    
    [view.layer addAnimation:animation forKey:@"hide"];
    
    callback();
}


#pragma mark - Tab Bar Animation Methods
+ (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
//    UIDevice *device = [UIDevice currentDevice];
//    CGFloat h = ([[device systemVersion] hasPrefix: @"6."]) ? 44
//    : tabbarcontroller.view.bounds.size.height;

    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          tabbarcontroller.view.bounds.size.height + view.bounds.size.height,
                                          view.bounds.size.width,
                                          view.bounds.size.height)];
            }];
        }
        else
        {
            //[view setFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height + h)];
        }
    }
}

+ (void)showTabBar:(UITabBarController *)tabbarcontroller
{
//    UIDevice *device = [UIDevice currentDevice];
//    CGFloat h = ([[device systemVersion] hasPrefix: @"6."]) ? 44
//    : tabbarcontroller.view.bounds.size.height;

    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                [view setFrame:CGRectMake(view.bounds.origin.x,
                                          tabbarcontroller.view.bounds.size.height - view.bounds.size.height,
                                          view.bounds.size.width, view.bounds.size.height)];
            }];
        }
        else
        {
            //[view setFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height - h)];
        }
    }
}
@end
