package com.appattestation

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule

abstract class AppAttestationSpec(context: ReactApplicationContext ) : ReactContextBaseJavaModule(context) {
  abstract fun attest(a: String, promise: Promise)
}
