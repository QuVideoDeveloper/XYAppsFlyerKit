//
//  XYAppsFlyerMgr.m
//  XYAppsFlyerKit
//
//  Created by Frenzy Feng on 2018/10/30.
//  Copyright (c) 2021 Hangzhou Xiaoying Innovation Technology Co., Ltd. All rights reserved.
//

#import "XYAppsFlyerMgr.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <XYCategory/XYCategory.h>

NSString * const XYPreferenceKeyAppsFlyer = @"XYPreferenceKeyAppsFlyer";

NSString * const XYAppsFlyerMediaSourceReceivedNotification = @"XYAppsFlyerMediaSourceReceivedNotification";

NSString * const XYAppsFlyerMediaSourceOrganic = @"Organic";
NSString * const XYAppsFlyerMediaSourceNonorganic = @"Non-organic";

NSString * const XYAppsFlyerKeyStatus       = @"af_status";
NSString * const XYAppsFlyerKeyMediaSource  = @"af_media_source";
NSString * const XYAppsFlyerKeyCampaign     = @"af_campaign";
NSString * const XYAppsFlyerKeyKeywords     = @"af_keywords";
NSString * const XYAppsFlyerKeyIsFB         = @"af_is_fb";
NSString * const XYAppsFlyerKeyFBCampaignId = @"af_fb_campaign_id";
NSString * const XYAppsFlyerKeyFBAdset      = @"af_fb_adset";
NSString * const XYAppsFlyerKeyFBAdsetId    = @"af_fb_adset_id";
NSString * const XYAppsFlyerKeyFBAdId       = @"af_fb_ad_id";
NSString * const XYAppsFlyerKeyAFChannel    = @"af_channel";
NSString * const XYAppsFlyerKeyAFAdset      = @"af_adset";
NSString * const XYAppsFlyerKeyAFAD         = @"af_ad";

/* Private */
NSString * const XYAFKeyIsFirstLaunch       = @"is_first_launch";

NSString * const XYAFKeyStatus       = @"af_status";
NSString * const XYAFKeyMediaSource  = @"media_source";
NSString * const XYAFKeyCampaign     = @"campaign";
NSString * const XYAFKeyKeywords     = @"af_keywords";
NSString * const XYAFKeyIsFB         = @"is_fb";
NSString * const XYAFKeyFBCampaignId = @"campaign_id";
NSString * const XYAFKeyFBAdset      = @"adset";
NSString * const XYAFKeyFBAdsetId    = @"adset_id";
NSString * const XYAFKeyFBAdId       = @"ad_id";

@interface XYAppsFlyerMgr () <AppsFlyerLibDelegate>

@end

@implementation XYAppsFlyerMgr

+ (instancetype) sharedInstance
{
    static XYAppsFlyerMgr * sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[XYAppsFlyerMgr alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadAttribution];
    }
    return self;
}

#pragma mark - Public

- (void) xy_appsFlyerInitWithAppsFlyerDevKey:(NSString *)appsFlyerDevKey appleAppID:(NSString *)appleAppID {
    
    [AppsFlyerLib shared].appsFlyerDevKey = appsFlyerDevKey;
    [AppsFlyerLib shared].appleAppID = appleAppID;
    [AppsFlyerLib shared].delegate = self;
#if DEBUG
    [AppsFlyerLib shared].useUninstallSandbox = NO;
#endif
}

- (void) xy_appsFlyerTrackAppLaunch {
    [[AppsFlyerLib shared] start];
}

- (void) xy_appsFlyerRegisterUninstall:(NSData *)deviceToken {
    [[AppsFlyerLib shared] registerUninstall:deviceToken];
}

- (NSString *) xy_appsFlyerUID {
    NSString *appsFlyerId = [[AppsFlyerLib shared] getAppsFlyerUID];
    return appsFlyerId;
}

- (BOOL) xy_appsFlyerIsNonorganic {
    if ([self compareStringEqual:self.mediaSource with:XYAppsFlyerMediaSourceNonorganic]) {
        return YES;
    }
    return NO;
}

- (void)xy_appsFlyerEvent:(NSString *)eventId attributes:(NSDictionary *)attributes {
    if ( [NSString xy_isEmpty:eventId] ) {
        return;
    }
    
    [[AppsFlyerLib shared] logEvent:eventId withValues:attributes];
}

#pragma mark - AppsFlyerTrackerDelegate

- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo {
    
    self.originConversionInfo = conversionInfo;
    NSDictionary *installData = conversionInfo;
    
    if (installData && installData.count > 0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        if (installData[XYAFKeyIsFirstLaunch]) {
            self.isFirstLaunch = [installData[XYAFKeyIsFirstLaunch] boolValue];
        }
        
        if (installData[XYAFKeyStatus]) {
            NSString *af_status = installData[XYAFKeyStatus];
            if ([self compareStringEqual:af_status with:XYAppsFlyerMediaSourceNonorganic]) {
                af_status = XYAppsFlyerMediaSourceNonorganic;
            } else {
                af_status = XYAppsFlyerMediaSourceOrganic;
            }
            self.mediaSource = af_status;
            [dict setValue:af_status forKey:XYAppsFlyerKeyStatus];
        }
        
        [dict setValue:[installData xyStringForKey:XYAFKeyMediaSource] forKey:XYAppsFlyerKeyMediaSource];
        [dict setValue:[installData xyStringForKey:XYAFKeyCampaign] forKey:XYAppsFlyerKeyCampaign];
        [dict setValue:[installData xyStringForKey:XYAFKeyKeywords] forKey:XYAppsFlyerKeyKeywords];
        [dict setValue:[installData xyStringForKey:XYAFKeyIsFB] forKey:XYAppsFlyerKeyIsFB];
        [dict setValue:[installData xyStringForKey:XYAFKeyFBCampaignId] forKey:XYAppsFlyerKeyFBCampaignId];
        [dict setValue:[installData xyStringForKey:XYAFKeyFBAdset] forKey:XYAFKeyFBAdset];
        [dict setValue:[installData xyStringForKey:XYAFKeyFBAdsetId] forKey:XYAppsFlyerKeyFBAdsetId];
        [dict setValue:[installData xyStringForKey:XYAFKeyFBAdId] forKey:XYAppsFlyerKeyFBAdId];
        [dict setValue:[installData xyStringForKey:XYAppsFlyerKeyAFChannel] forKey:XYAppsFlyerKeyAFChannel];
        [dict setValue:[installData xyStringForKey:XYAppsFlyerKeyAFAD] forKey:XYAppsFlyerKeyAFAD];
        [dict setValue:[installData xyStringForKey:XYAppsFlyerKeyAFAdset] forKey:XYAppsFlyerKeyAFAdset];
        
        [self saveAttribution:dict];
    }

    [self notifyMediaSourceReceived];
}

- (void)onConversionDataFail:(NSError *)error {
    NSLog(@"onConversionDataRequestFailure error: %@", error.localizedDescription);
    self.originConversionError = error;
    [self notifyMediaSourceReceived];
}

#pragma mark - Preference

- (void)loadAttribution {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:XYPreferenceKeyAppsFlyer];
    if (dict) {
        //已归因
        self.mediaSourceDict = dict;
        NSString *af_status = self.mediaSourceDict[XYAFKeyStatus];
        if ([self compareStringEqual:af_status with:XYAppsFlyerMediaSourceNonorganic]) {
            af_status = XYAppsFlyerMediaSourceNonorganic;
        } else {
            af_status = XYAppsFlyerMediaSourceOrganic;
        }
        self.mediaSource = af_status;
        [self notifyMediaSourceReceived];
    }
}

- (void)saveAttribution:(NSDictionary *)dict {
    if (dict && dict.count > 0) {
        self.mediaSourceDict = dict;
        [[NSUserDefaults standardUserDefaults] setValue:dict forKey:XYPreferenceKeyAppsFlyer];
    }
}

#pragma mark - Private

- (void)notifyMediaSourceReceived {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XYAppsFlyerMediaSourceReceivedNotification object:self userInfo:nil];
    });
}

- (BOOL)compareStringEqual:(NSString *)string1 with:(NSString *)string2 {
    BOOL result = NO;
    if (string1 && string2) {
        result = ([string1 caseInsensitiveCompare:string2] == NSOrderedSame);
    }
    return result;
}

@end
