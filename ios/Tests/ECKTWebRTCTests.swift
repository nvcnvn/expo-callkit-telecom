// Swift allocates through objc_allocWithZone rather than +alloc; this checks that path also yields
// the app's class.
@_cdecl("ECKTTestSwiftNewConfiguration")
func newConfigurationFromSwift() -> AnyObject {
  ECKTRTCAudioSessionConfiguration()
}
