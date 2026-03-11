package com.appattestation

import com.facebook.react.bridge.ReactApplicationContext

class AppAttestationModule(reactContext: ReactApplicationContext) :
  NativeAppAttestationSpec(reactContext) {

  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  companion object {
    const val NAME = NativeAppAttestationSpec.NAME
  }
}
