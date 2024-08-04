//
//  Sequance+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 06.10.2023.
//

import Foundation

extension Collection {

	func firstIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equalsTo value: T) -> Index? {
		return firstIndex { element in
			element[keyPath: keyPath] == value
		}
	}
}
