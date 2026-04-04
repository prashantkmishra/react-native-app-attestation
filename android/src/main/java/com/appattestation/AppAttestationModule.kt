package com.appattestation

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.google.android.play.core.integrity.*


@ReactModule(name = AppAttestationModule.NAME)
class AppAttestationModule(private val reactContext: ReactApplicationContext) :
  AppAttestationSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun attest(nonce: String, promise: Promise) {
    try {
      val integrityManager = IntegrityManagerFactory.create(reactContext)
      val cloudProjectNumber = 411060211933
      val request = IntegrityTokenRequest.builder()
        .setCloudProjectNumber(cloudProjectNumber)
        .setNonce(nonce)
        .build()

      integrityManager.requestIntegrityToken(request)
        .addOnSuccessListener { response ->
          val token = response.token()
          val map = Arguments.createMap()
          map.putString("platform", "android")
          map.putString("token", token)
          promise.resolve(map)
        }.addOnFailureListener {
          promise.reject("PLAY_INTEGRITY_ERROR", it)
        }
    } catch (exception: Exception) {
        promise.reject("PLAY_INTEGRITY_ERROR", exception.message)
    }

  }

  companion object {
    const val NAME = "AppAttestation"
  }
}
