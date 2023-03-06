//
//  KeychainManager.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import Foundation
import Security

class KeychainManager {
    
    private static let serviceName = "apikey"
    
    static func saveApiKey(_ apiKey: String) -> Bool {
        guard let apiKeyData = apiKey.data(using: .utf8) else {
            return false
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecValueData: apiKeyData
        ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }
    
    static func getApiKey() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess, let apiKeyData = result as? Data else {
            return nil
        }
        
        return String(data: apiKeyData, encoding: .utf8)
    }
    
    static func deleteApiKey() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
    
}
