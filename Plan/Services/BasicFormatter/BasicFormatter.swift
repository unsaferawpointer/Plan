//
//  BasicFormatter.swift
//  Plan
//
//  Created by Anton Cherkasov on 13.08.2024.
//

import Foundation

protocol BasicFormatterProtocol {
	func format(nodes: [Node<ItemContent>]) -> String
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

	func format(nodes: [Node<ItemContent>]) -> String {

		var lines: [String] = []

		for node in filter(nodes: nodes) {
			let nodeLines = text(for: node, indent: 0)
			lines.append(contentsOf: nodeLines)
		}

		return lines.joined(separator: "\n")
	}
}

// MARK: - Helpers
private extension BasicFormatter {

	func filter(nodes: [Node<ItemContent>]) -> [Node<ItemContent>] {
		var children = Set<UUID>()

		for node in nodes {
			var queue = [node]
			while !queue.isEmpty {
				let current = queue.remove(at: 0)
				children.insert(current.id)
				for child in current.children {
					queue.append(child)
				}
			}
			children.remove(node.id)
		}

		return nodes.filter { node in
			!children.contains(node.id)
		}
	}

	func text(for node: Node<ItemContent>, indent: Int) -> [String] {
		let indentPrefix = Array(repeating: format.indent.value, count: indent).joined()
		let line = indentPrefix + format.prefix.sign + node.value.text
		return [line] + node.children.flatMap { text(for: $0, indent: indent + 1) }
	}

	func childrens(_ root: Node<ItemContent>) -> Set<UUID> {


		var queue = [root]

		var result = Set<UUID>()

		while !queue.isEmpty {

			let current = queue.remove(at: 0)
			result.insert(current.id)
			for child in current.children {
				queue.append(child)
			}
		}

		result.remove(root.id)

		return result
	}
}

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
