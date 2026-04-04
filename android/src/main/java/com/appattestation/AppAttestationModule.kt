package com.appattestation

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = AppAttestationModule.NAME)
class AppAttestationModule(reactContext: ReactApplicationContext) :
  AppAttestationSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun multiply(a: Double, b: Double, promise: Promise) {
    try {
      val result = a * b
      promise.resolve(result)
    } catch (e: Exception) {
      promise.reject("MULTIPLY_ERROR", e)
    }
  }

  companion object {
    const val NAME = "AppAttestation"
  }
}
