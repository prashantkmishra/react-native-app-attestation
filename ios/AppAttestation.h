#import <React/RCTBridgeModule.h>

@class AppAttestationImpl;

#ifdef RCT_NEW_ARCH_ENABLED
#import <AppAttestationSpec/AppAttestationSpec.h>
@interface AppAttestation : NSObject <NativeAppAttestationSpec>
#else
@interface AppAttestation : NSObject <RCTBridgeModule>
#endif

@end
