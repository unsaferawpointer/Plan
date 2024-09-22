//
//  BasicFormatter.swift
//  Plan
//
//  Created by Anton Cherkasov on 13.08.2024.
//

import Foundation

protocol BasicFormatterProtocol {
	func format(_ node: any TreeNode<ItemContent>) -> String
}

final class BasicFormatter {

	let format: Format

	// MARK: - Initialization

	init(format: Format = Format(indent: .tab, prefix: .dash)) {
		self.format = format
	}
}

// MARK: - BasicFormatterProtocol
extension BasicFormatter: BasicFormatterProtocol {

	func format(_ node: any TreeNode<ItemContent>) -> String {
		return text(for: node, indent: 0).joined(separator: "\n")
	}
}

// MARK: - Helpers
private extension BasicFormatter {

	func filter(nodes: [any TreeNode<ItemContent>]) -> [any TreeNode<ItemContent>] {

		var cache = Set<UUID>()

		let flatten = nodes.flatMap { $0.children }

		for node in flatten {
			guard !cache.contains(node.id) else {
				continue
			}
			var queue = [node]
			while !queue.isEmpty {
				let current = queue.remove(at: 0)
				cache.insert(current.id)
				for child in current.children {
					queue.insert(child, at: 0)
				}
			}
		}

		return nodes.filter { node in
			!cache.contains(node.id)
		}
	}

	func text(for node: any TreeNode<ItemContent>, indent: Int) -> [String] {
		let indentPrefix = Array(repeating: format.indent.value, count: indent).joined()
		let line = indentPrefix + format.prefix.sign + " " + node.value.text
		return [line] + node.children.flatMap { text(for: $0, indent: indent + 1) }
	}
}

// MARK: - Nested data structs
extension BasicFormatter {

	struct Format {
		var indent: Indent
		var prefix: Prefix
	}

	enum Indent {
		case space(value: Int)
		case tab

		var value: String {
			switch self {
			case .space(let value):
				return Array(repeating: " ", count: value).joined()
			case .tab:
				return "\t"
			}
		}
	}

	enum Prefix {

		case asterics
		case dash

		var sign: String {
			switch self {
			case .asterics:
				return "*"
			case .dash:
				return "-"
			}
		}
	}
}
