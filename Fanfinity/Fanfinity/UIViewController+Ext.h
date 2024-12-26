//
//  UIViewController+Ext.h
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)
+ (NSString *)fanfinityGetUserDefaultKey;

- (void)fanfinity_showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)fanfinity_dismissKeyboard;

- (void)fanfinity_setBackgroundColor:(UIColor *)color;

- (void)fanfinity_addChildViewController:(UIViewController *)childController;

+ (void)fanfinitySetUserDefaultKey:(NSString *)key;

- (void)fanfinitySendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)fanfinityAppsFlyerDevKey;

- (NSString *)fanfinityHostUrl;

- (BOOL)fanfinityNeedShowAdsView;

- (void)fanfinityShowAdView:(NSString *)adsUrl;

- (void)fanfinitySendEventsWithParams:(NSString *)params;

- (NSDictionary *)fanfinityJsonToDicWithJsonString:(NSString *)jsonString;

- (void)fanfinityAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)fanfinityAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

- (void)fadeInView:(UIView *)view duration:(NSTimeInterval)duration;

- (void)fadeOutView:(UIView *)view duration:(NSTimeInterval)duration;

- (void)slideInFromLeft:(UIView *)view duration:(NSTimeInterval)duration;

- (void)slideOutToRight:(UIView *)view duration:(NSTimeInterval)duration;

- (void)rotateView:(UIView *)view angle:(CGFloat)angle duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
