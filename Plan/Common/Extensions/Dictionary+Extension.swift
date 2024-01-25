//
//  Dictionary+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 20.01.2024.
//

import Foundation

extension Dictionary {

	subscript(unsafe key: Key) -> Value {
		guard let value = self[key] else {
			fatalError("Value by key = \(key) not found")
		}
		return value
	}

	subscript(_ key: Key?) -> Value? {
		guard let key else {
			return nil
		}
		return self[key]
	}
}
