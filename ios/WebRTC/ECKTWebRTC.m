#import "ECKTWebRTC.h"

#import <os/log.h>

// Both RTC classes always come from the same build: LiveKitWebRTC's LK-prefixed one if linked,
// otherwise the unprefixed one every other build vends.
static NSString *ECKTRTCPrefix(void) {
  BOOL hasLiveKit = NSClassFromString(@"LKRTCAudioSession") != nil;
  // Apps should ship one WebRTC build. With two, nothing at runtime says which one the
  // react-native-webrtc module uses, and configuring the other leaves calls without audio.
  if (hasLiveKit && NSClassFromString(@"RTCAudioSession") != nil) {
    static dispatch_once_t warnOnce;
    dispatch_once(&warnOnce, ^{
      os_log_fault(OS_LOG_DEFAULT,
                   "expo-callkit-telecom: both LKRTCAudioSession and RTCAudioSession are linked; "
                   "using LKRTCAudioSession. Ship one WebRTC build.");
    });
  }
  return hasLiveKit ? @"LK" : @"";
}

static Class ECKTWebRTCClass(NSString *name) {
  Class cls = NSClassFromString(name);
  if (cls == nil) {
    [NSException raise:NSInternalInconsistencyException
                format:@"expo-callkit-telecom: no %@ class is linked. Add a react-native-webrtc "
                       @"build (@livekit/react-native-webrtc, react-native-webrtc >= 124.0.5 or a "
                       @"fork) to the app.",
                       name];
  }
  return cls;
}

static Class ECKTRTCClass(NSString *name) {
  return ECKTWebRTCClass([ECKTRTCPrefix() stringByAppendingString:name]);
}

@implementation ECKTRTCAudioSessionConfiguration

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  return [ECKTRTCClass(@"RTCAudioSessionConfiguration") allocWithZone:zone];
}

+ (void)setWebRTCConfiguration:(ECKTRTCAudioSessionConfiguration *)configuration {
  [(id)ECKTRTCClass(@"RTCAudioSessionConfiguration") setWebRTCConfiguration:configuration];
}

@end

@implementation ECKTRTCAudioSession

+ (instancetype)sharedInstance {
  return [(id)ECKTRTCClass(@"RTCAudioSession") sharedInstance];
}

@end

@implementation ECKTWebRTCModuleOptions

+ (instancetype)sharedInstance {
  return [(id)ECKTWebRTCClass(@"WebRTCModuleOptions") sharedInstance];
}

@end
