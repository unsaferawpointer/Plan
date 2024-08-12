//
//  Collection+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.08.2024.
//

import Foundation

extension Collection {

	func firstIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equalsTo value: T) -> Index? {
		return firstIndex { element in
			element[keyPath: keyPath] == value
		}
	}
}
