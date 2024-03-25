//
//  SettingsStorage.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.03.2024.
//

import Foundation

protocol SettingsStorageProtocol {
	func getValue<T: RawRepresentable>(type: T.Type, withKey key: String) -> T? where T.RawValue == String
	func setValue<T: RawRepresentable>(value: T, withKey key: String) where T.RawValue == String
}

final class SettingsStorage { 

	init() {}
}

// MARK: - SettingsStorageProtocol
extension SettingsStorage: SettingsStorageProtocol {

	func getValue<T: RawRepresentable>(type: T.Type, withKey key: String) -> T? where T.RawValue == String {
		guard let rawValue = UserDefaults.standard.string(forKey: key) else {
			return nil
		}
		return T(rawValue: rawValue)
	}

	func setValue<T: RawRepresentable>(value: T, withKey key: String) where T.RawValue == String {
		UserDefaults.standard.set(value.rawValue, forKey: key)
	}
}
