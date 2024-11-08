//
//  AnyModification.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.10.2024.
//

import Foundation

struct AnyModification<Object, Value>: Modification {

	var keyPath: WritableKeyPath<Object, Value>
	
	var value: Value

	init(keyPath: WritableKeyPath<Object, Value>, value: Value) {
		self.keyPath = keyPath
		self.value = value
	}
}
