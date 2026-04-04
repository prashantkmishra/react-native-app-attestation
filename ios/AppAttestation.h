#import <React/RCTBridgeModule.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "AppAttestationSpec.h"
#endif

@interface AppAttestation : NSObject <RCTBridgeModule
#ifdef RCT_NEW_ARCH_ENABLED
, NativeAppAttestationSpec
#endif
>

@end