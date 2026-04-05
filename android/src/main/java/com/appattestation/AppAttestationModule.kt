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
  override fun attest(nonce: String, cloudProjectNumber: String?, promise: Promise) {
    try {
      val integrityManager = IntegrityManagerFactory.create(reactContext)
      val requestBuilder = IntegrityTokenRequest.builder()
        .setNonce(nonce)
      if (cloudProjectNumber != null) {
        requestBuilder.setCloudProjectNumber(cloudProjectNumber.toLong())
      } else {
        promise.reject("INTEGRITY_ERROR", "Invalid cloudProjectNumber")
        return
      }
      integrityManager.requestIntegrityToken(requestBuilder.build())
        .addOnSuccessListener { response ->
          val token = response.token()
          val map = Arguments.createMap()
          map.putString("platform", "android")
          map.putString("token", token)
          promise.resolve(map)
        }.addOnFailureListener {
          promise.reject("INTEGRITY_ERROR", it)
        }
    } catch (exception: Exception) {
        promise.reject("INTEGRITY_ERROR", exception.message)
    }

  }

  companion object {
    const val NAME = "AppAttestation"
  }
}
