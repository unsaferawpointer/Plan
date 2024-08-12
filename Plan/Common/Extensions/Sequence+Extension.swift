//
//  Sequance+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 06.10.2023.
//

import Foundation

extension Sequence {

	public func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> T? {
		return map {
			$0[keyPath: keyPath]
		}.min()
	}
}
