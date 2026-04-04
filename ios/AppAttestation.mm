#import "AppAttestation.h"

@implementation AppAttestation

RCT_EXPORT_MODULE(AppAttestation)

#pragma mark - Old Architecture (Bridge)

RCT_EXPORT_METHOD(multiply:(double)a
                  b:(double)b
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@(a * b));
}

#pragma mark - New Architecture (TurboModule)

#ifdef RCT_NEW_ARCH_ENABLED

// This method MUST match Codegen spec (NO resolver/rejecter)
- (void)multiply:(double)a
               b:(double)b
         resolve:(RCTPromiseResolveBlock)resolve
          reject:(RCTPromiseRejectBlock)reject
{
    resolve(@(a * b));
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAppAttestationSpecJSI>(params);
}

#endif

@end