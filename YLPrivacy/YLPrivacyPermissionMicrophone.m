//
//  YLPrivacyPermissionMicrophone.m
//  YLPrivacyPermission
//
//  Created by xyanl on 2020/11/9.
//

#import "YLPrivacyPermissionMicrophone.h"
#import <AVFoundation/AVFoundation.h>

#define kHasBeenAskedForMicrophonePermission @"HasBeenAskedForMicrophonePermission"

@implementation YLPrivacyPermissionMicrophone

+ (BOOL)authorized
{
    return [self authorizationStatus] == AVAudioSessionRecordPermissionGranted;
}


//AVAudioSessionRecordPermissionUndetermined        = 'undt',
//AVAudioSessionRecordPermissionDenied            = 'deny',
//AVAudioSessionRecordPermissionGranted            = 'grnt'



/**
 permission status
 
 0 ：AVAudioSessionRecordPermissionUndetermined
 1 ：AVAudioSessionRecordPermissionDenied
 2 ：AVAudioSessionRecordPermissionGranted
 
 @return status
 */
+ (NSInteger)authorizationStatus
{
    if ( @available(iOS 8,*) ){
        return [[AVAudioSession sharedInstance] recordPermission];
    } else if (@available(iOS 7,*)) {
        bool hasBeenAsked =
        [[NSUserDefaults standardUserDefaults] boolForKey:kHasBeenAskedForMicrophonePermission];
        if (hasBeenAsked) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL hasAccess;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                hasAccess = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            return hasAccess ? AVAudioSessionRecordPermissionGranted : AVAudioSessionRecordPermissionDenied;
        } else {
            return AVAudioSessionRecordPermissionUndetermined;
        }
    }
    return AVAudioSessionRecordPermissionGranted;
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    if (@available(iOS 8.0, *)) {
        
        AVAudioSessionRecordPermission permission = [audioSession recordPermission];
        switch (permission) {
            case AVAudioSessionRecordPermissionGranted: {
                if (completion) {
                    completion(YES, NO);
                }
            } break;
            case AVAudioSessionRecordPermissionDenied: {
                if (completion) {
                    completion(NO, NO);
                }
            } break;
            case AVAudioSessionRecordPermissionUndetermined:
            {
                AVAudioSession *session = [[AVAudioSession alloc] init];
                NSError *error;
                [session setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:&error];
                [session requestRecordPermission:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                }];
            }  break;
            default:
            {
                completion(NO,YES);
            }
                break;
        }
    } else if([audioSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [audioSession requestRecordPermission:^(BOOL granted) {
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            if (completion) {
                BOOL hasBeenAskedPermission = [ud boolForKey:kHasBeenAskedForMicrophonePermission];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted,!hasBeenAskedPermission);
                });
            }
            
            [ud setBool:YES forKey:kHasBeenAskedForMicrophonePermission];
            [ud synchronize];
        }];
    }
    
    completion(YES, NO);
}

/// 当前隐私许可状态描述
+ (NSString *)authorizationStatusDescribe{
    NSString *strPermission = @"";
    switch ([YLPrivacyPermissionMicrophone authorizationStatus]) {
        case AVAudioSessionRecordPermissionUndetermined:
            strPermission = @"权限未确定";
            break;
        case AVAudioSessionRecordPermissionDenied:
            strPermission = @"没有权限";
            break;
        case AVAudioSessionRecordPermissionGranted:
            strPermission = @"权限已经获取";
            break;
        default:
            break;
    }
    return strPermission;
}

@end
