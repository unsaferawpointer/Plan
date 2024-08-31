//
//  BasicFormatterMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

@testable import Plan

final class BasicFormatterMock {
	var stubs = Stubs()
}

// MARK: - BasicFormatterProtocol
extension BasicFormatterMock: BasicFormatterProtocol {

	func format(nodes: [any TreeNode<ItemContent>]) -> String {
		stubs.format
	}

	func texts(for nodes: [any TreeNode<ItemContent>]) -> [String] {
		stubs.texts
	}
}

// MARK: - Nested data structs
extension BasicFormatterMock {

	struct Stubs {
		var format: String = .random
		var texts: [String] = []
	}
}
