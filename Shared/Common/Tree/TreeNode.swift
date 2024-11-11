//
//  TreeNode.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 13.11.2023.
//

import Foundation

protocol TreeNode<Value> {

	associatedtype Value: Identifiable

	var value: Value { get set }

	var children: [Self] { get }
}

extension TreeNode {

	var id: Value.ID {
		value.id
	}
}

extension TreeNode {

	func enumerate(_ block: (Self) -> Void) {
		block(self)
		for node in children {
			node.enumerate(block)
		}
	}

	var descedantsCount: Int {
		guard !children.isEmpty else {
			return 0
		}
		return children.reduce(0) { partialResult, node in
			return partialResult + node.count
		}
	}

	var count: Int {
		guard !children.isEmpty else {
			return 1
		}
		return children.reduce(0) { partialResult, node in
			return partialResult + node.count
		}
	}

	func reduce(_ keyPath: KeyPath<Value, Bool>) -> Bool {
		guard !children.isEmpty else {
			return value[keyPath: keyPath]
		}
		return children.allSatisfy { entity in
			return entity.reduce(keyPath)
		}
	}

	func reduce(_ keyPath: KeyPath<Value, Int>) -> Int {
		guard !children.isEmpty else {
			return value[keyPath: keyPath]
		}
		return children.reduce(0) { partialResult, node in
			return partialResult + node.reduce(keyPath)
		}
	}

	func allSatisfy<T: Equatable>(_ keyPath: KeyPath<Value, T>, equalsTo value: T) -> Bool {
		guard !children.isEmpty else {
			return self.value[keyPath: keyPath] == value
		}
		return children.allSatisfy {
			$0.allSatisfy(keyPath, equalsTo: value)
		}
	}


}
