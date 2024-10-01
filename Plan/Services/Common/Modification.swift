//
//  Modification.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.10.2024.
//

import Foundation

protocol Modification<Object> {

	associatedtype Object

	associatedtype Value

	var keyPath: WritableKeyPath<Object, Value> { get }

	var value: Value { get }
}
