#import "ECKTWebRTC.h"

static Class ECKTWebRTCClass(NSString *name) {
  Class cls = NSClassFromString([@"LK" stringByAppendingString:name]) ?: NSClassFromString(name);
  if (cls == nil) {
    [NSException raise:NSInternalInconsistencyException
                format:@"expo-callkit-telecom: no %@ class is linked. Add a WebRTC build such as "
                       @"@livekit/react-native-webrtc to the app.",
                       name];
  }
  return cls;
}

@implementation ECKTRTCAudioSessionConfiguration

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  return [ECKTWebRTCClass(@"RTCAudioSessionConfiguration") allocWithZone:zone];
}

+ (void)setWebRTCConfiguration:(ECKTRTCAudioSessionConfiguration *)configuration {
  [(id)ECKTWebRTCClass(@"RTCAudioSessionConfiguration") setWebRTCConfiguration:configuration];
}

@end

@implementation ECKTRTCAudioSession

+ (instancetype)sharedInstance {
  return [(id)ECKTWebRTCClass(@"RTCAudioSession") sharedInstance];
}

@end

@implementation ECKTWebRTCModuleOptions

+ (instancetype)sharedInstance {
  return [(id)ECKTWebRTCClass(@"WebRTCModuleOptions") sharedInstance];
}

@end
