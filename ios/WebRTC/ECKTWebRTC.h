/*
 *  Declarations follow WebRTC's sdk/objc/components/audio/RTCAudioSession.h and
 *  RTCAudioSessionConfiguration.h (Copyright 2016 The WebRTC Project Authors, BSD-style license,
 *  https://webrtc.googlesource.com/src/+/main/LICENSE) and react-native-webrtc's
 *  WebRTCModuleOptions.h (MIT).
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Stand-ins for the WebRTC and react-native-webrtc classes this module calls. The pod links no
// WebRTC binary, and WebRTC builds name these classes differently (LiveKitWebRTC vends
// LKRTCAudioSession, upstream WebRTC RTCAudioSession), so each stand-in looks up the app's class
// at runtime and hands out instances of that class. Only the subset this module calls is declared.

@interface ECKTRTCAudioSessionConfiguration : NSObject
+ (void)setWebRTCConfiguration:(ECKTRTCAudioSessionConfiguration *)configuration;
@end

@interface ECKTRTCAudioSessionConfiguration (WebRTC)
@property(nonatomic, strong) NSString *category;
@property(nonatomic, assign) AVAudioSessionCategoryOptions categoryOptions;
@property(nonatomic, strong) NSString *mode;
@end

@interface ECKTRTCAudioSession : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedInstance;
@end

@interface ECKTRTCAudioSession (WebRTC)
@property(nonatomic, readonly) BOOL isActive;
@property(nonatomic, assign) BOOL useManualAudio;
@property(nonatomic, assign) BOOL isAudioEnabled;
- (void)lockForConfiguration;
- (void)unlockForConfiguration;
- (void)audioSessionDidActivate:(AVAudioSession *)session;
- (void)audioSessionDidDeactivate:(AVAudioSession *)session;
- (BOOL)overrideOutputAudioPort:(AVAudioSessionPortOverride)portOverride
                          error:(NSError **)outError;
- (BOOL)setConfiguration:(ECKTRTCAudioSessionConfiguration *)configuration
                   error:(NSError **)outError;
@end

@interface ECKTWebRTCModuleOptions : NSObject
+ (instancetype)sharedInstance;
@end

@interface ECKTWebRTCModuleOptions (WebRTC)
@property(nonatomic, assign) BOOL enableMultitaskingCameraAccess;
@end

NS_ASSUME_NONNULL_END
