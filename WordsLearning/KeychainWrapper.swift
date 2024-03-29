//
//  KeychainWrapper.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.08.2022.
//

import Security
import UIKit

protocol KeychainWrapperProtocol {

	@discardableResult
	func save(key: String, data: Data) -> OSStatus

	func load(key: String) -> Data?
}

final class KeychainWrapper: KeychainWrapperProtocol {

	@discardableResult
	func save(key: String, data: Data) -> OSStatus {
		let query = [
			kSecClass as String       : kSecClassGenericPassword as String,
			kSecAttrAccount as String : key,
			kSecValueData as String   : data ] as [String : Any]

		SecItemDelete(query as CFDictionary)

		return SecItemAdd(query as CFDictionary, nil)
	}

	func load(key: String) -> Data? {
		let query = [
			kSecClass as String       : kSecClassGenericPassword,
			kSecAttrAccount as String : key,
			kSecReturnData as String  : kCFBooleanTrue!,
			kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

		var dataTypeRef: AnyObject? = nil

		let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

		return status == noErr ? dataTypeRef as! Data? : nil
	}

	// MARK: Private

	private func createUniqueID() -> String {
		let uuid: CFUUID = CFUUIDCreate(nil)
		let cfStr: CFString = CFUUIDCreateString(nil, uuid)

		let swiftString: String = cfStr as String
		return swiftString
	}
}
