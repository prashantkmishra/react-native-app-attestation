#import "AppAttestation.h"
#import "AppAttestation-Swift.h"

@implementation AppAttestation
RCT_EXPORT_MODULE()

// Helper to handle the actual logic for both architectures
- (void)runAttestation:(NSString *)nonce
resolve:(RCTPromiseResolveBlock)resolve
reject:(RCTPromiseRejectBlock)reject {
  
  // 1. Create the instance
  AppAttestationImpl *swiftInstance = [[AppAttestationImpl alloc] init];
  
  // 2. Call the method.
  // The first parameter has no label in Swift (_), so it's just 'attest:'
  // The second parameter is 'completionHandler:'
  [swiftInstance attest:nonce completionHandler:^(NSDictionary<NSString *,id> * _Nullable result, NSError * _Nullable error) {
    if (error) {
      reject([NSString stringWithFormat:@"%ld", (long)error.code],
             error.localizedDescription,
             error);
    } else {
      resolve(result);
    }
  }];
}

// --- OLD ARCHITECTURE BRIDGE ---
RCT_REMAP_METHOD(attest,
                 attestWithNonce:(NSString *)nonce
                 cloudProjectNumber:(NSString *)cloudProjectNumber
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  [self runAttestation:nonce resolve:resolve reject:reject];
}


// --- NEW ARCHITECTURE (TURBOMODULE) ---
#ifdef RCT_NEW_ARCH_ENABLED
- (void)attest:(NSString *)nonce cloudProjectNumber:(NSString *)cloudProjectNumber
       resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [self runAttestation:nonce resolve:resolve reject:reject];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeAppAttestationSpecJSI>(params);
}
#endif

@end
