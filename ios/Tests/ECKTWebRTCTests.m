#import <objc/runtime.h>

#import "../WebRTC/ECKTWebRTC.h"

extern id ECKTTestSwiftNewConfiguration(void);

static int failures = 0;

#define CHECK(cond)                                                    \
  do {                                                                 \
    if (!(cond)) {                                                     \
      fprintf(stderr, "FAIL %s:%d: %s\n", __FILE__, __LINE__, #cond); \
      failures++;                                                      \
    }                                                                  \
  } while (0)

static id lastWebRTCConfiguration;

// Registers a class the way the app's WebRTC build would vend it, with the class methods the
// stand-ins forward to.
static Class registerWebRTCClass(const char *name) {
  Class cls = objc_allocateClassPair([NSObject class], name, 0);
  class_addMethod(object_getClass(cls), @selector(sharedInstance),
                  imp_implementationWithBlock(^id(Class self) { return [[self alloc] init]; }), "@@:");
  class_addMethod(object_getClass(cls), @selector(setWebRTCConfiguration:),
                  imp_implementationWithBlock(^(Class self, id configuration) {
                    lastWebRTCConfiguration = configuration;
                  }),
                  "v@:@");
  objc_registerClassPair(cls);
  return cls;
}

static NSString *inconsistencyReason(void (^block)(void)) {
  @try {
    block();
  } @catch (NSException *e) {
    return [e.name isEqualToString:NSInternalInconsistencyException] ? e.reason : nil;
  }
  return nil;
}

int main(void) {
  @autoreleasepool {
    NSString *reason = inconsistencyReason(^{ [ECKTRTCAudioSession sharedInstance]; });
    CHECK([reason containsString:@"no RTCAudioSession class is linked"]);
    reason = inconsistencyReason(^{ (void)[[ECKTRTCAudioSessionConfiguration alloc] init]; });
    CHECK([reason containsString:@"no RTCAudioSessionConfiguration class is linked"]);

    Class upstreamSession = registerWebRTCClass("RTCAudioSession");
    CHECK([[ECKTRTCAudioSession sharedInstance] class] == upstreamSession);

    Class liveKitSession = registerWebRTCClass("LKRTCAudioSession");
    CHECK([[ECKTRTCAudioSession sharedInstance] class] == liveKitSession);

    Class liveKitConfiguration = registerWebRTCClass("LKRTCAudioSessionConfiguration");
    ECKTRTCAudioSessionConfiguration *configuration = [[ECKTRTCAudioSessionConfiguration alloc] init];
    CHECK([configuration class] == liveKitConfiguration);
    CHECK([ECKTTestSwiftNewConfiguration() class] == liveKitConfiguration);
    [ECKTRTCAudioSessionConfiguration setWebRTCConfiguration:configuration];
    CHECK(lastWebRTCConfiguration == configuration);

    Class moduleOptions = registerWebRTCClass("WebRTCModuleOptions");
    CHECK([[ECKTWebRTCModuleOptions sharedInstance] class] == moduleOptions);
  }
  if (failures == 0) printf("ECKTWebRTC tests passed\n");
  return failures == 0 ? 0 : 1;
}
