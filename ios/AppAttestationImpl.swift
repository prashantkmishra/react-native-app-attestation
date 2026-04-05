import Foundation
import DeviceCheck
import CryptoKit

@objc(AppAttestationImpl)
public class AppAttestationImpl: NSObject {
  
  private let keychainKey = "app_attest_key_id"
  
  @objc public override init() { super.init() }
  
  // MARK: - PUBLIC (ObjC exposed wrapper)
  // This is called from .m / .mm
  @objc(attest:completionHandler:)
  public func attest(
    _ nonce: String,
    completionHandler: @escaping ([String: Any]?, NSError?) -> Void
  ){
    guard #available(iOS 15.0, *) else {
      completionHandler(nil, NSError(
        domain: "AppAttestation",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "iOS 15+ required"]
      ))
      return
    }
    
    Task {
      do {
        let result = try await self.performAttestation(nonce)
        completionHandler(result, nil)
      } catch {
        completionHandler(nil, error as NSError)
      }
    }
  }
  
  // MARK: - CORE LOGIC (PURE SWIFT)
  @available(iOS 15.0, *)
  private func performAttestation(_ nonce: String) async throws -> [String: Any] {
    
    let service = DCAppAttestService.shared
    
    guard service.isSupported else {
      throw NSError(
        domain: "AppAttestation",
        code: 2,
        userInfo: [NSLocalizedDescriptionKey: "App Attest not supported"]
      )
    }
    
    let keyId = try await getOrCreateKey(service)
    
    guard let nonceData = nonce.data(using: .utf8) else {
      throw NSError(
        domain: "AppAttestation",
        code: 3,
        userInfo: [NSLocalizedDescriptionKey: "Invalid nonce"]
      )
    }
    
    let hash = SHA256.hash(data: nonceData)
    
    return try await withCheckedThrowingContinuation { continuation in
      service.attestKey(keyId, clientDataHash: Data(hash)) { attestation, error in
        
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        
        guard let attestation = attestation else {
          continuation.resume(throwing: NSError(
            domain: "AppAttestation",
            code: 4,
            userInfo: [NSLocalizedDescriptionKey: "No attestation received"]
          ))
          return
        }
        
        continuation.resume(returning: [
          "platform": "ios",
          "keyId": keyId,
          "token": attestation.base64EncodedString()
        ])
      }
    }
  }
  
  // MARK: - KEY MANAGEMENT
  
  @available(iOS 15.0, *)
  private func getOrCreateKey(_ service: DCAppAttestService) async throws -> String {
    if let existing = getKey() {
      return existing
    }
    
    let keyId = try await service.generateKey()
    saveKey(keyId)
    return keyId
  }
  
  private func saveKey(_ key: String) {
    let data = key.data(using: .utf8)!
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: keychainKey,
      kSecValueData as String: data
    ]
    
    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }
  
  private func getKey() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: keychainKey,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess,
       let data = result as? Data,
       let key = String(data: data, encoding: .utf8) {
      return key
    }
    
    return nil
  }
}
