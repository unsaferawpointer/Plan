//
//  TextParser.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.08.2024.
//

import Foundation

protocol TextParserProtocol {
	func parse(from text: String) -> [any TreeNode<ItemContent>]
}

final class TextParser {

	var configuration: ParserConfiguration

	// MARK: - Initialization

	init(configuration: ParserConfiguration) {
		self.configuration = configuration
	}
}

// MARK: - TextParserProtocol
extension TextParser: TextParserProtocol {

	func parse(from text: String) -> [any TreeNode<ItemContent>] {

		var result: [Node<ItemContent>] = []
		var cache: [Int: Node<ItemContent>] = [:]

		var lines = parseLines(text: text)
		trim(&lines)
		normalize(&lines)
		removePrefix(&lines)

		for line in lines {
			let trimmed = line.text.trimmingCharacters(in: .whitespacesAndNewlines)
			let node = Node<ItemContent>(
				value: .init(
					uuid: .init(),
					text: trimmed
				)
			)

			if let parent = cache[line.indent - 1] {
				parent.children.append(node)
			}

			if line.indent == 0 {
				result.append(node)
			}

			cache[line.indent] = node
		}
		return result
	}
}

// MARK: - Helpers
private extension TextParser {

	func indent(for line: String) -> Int {
		var count = 0
		for character in line {
			switch character {
			case "\u{00A0}":
				count += 1
			case "\t":
				count += configuration.indentWidth
			default:
				return count / configuration.indentWidth
			}
		}
		return count / configuration.indentWidth
	}

	func parseLines(text: String) -> [Line] {
		var result: [Line] = []
		text.enumerateLines { line, stop in
			let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
			guard !trimmed.isEmpty else {
				return
			}
			let indent = self.indent(for: line)
			let line = Line(indent: indent, text: trimmed)
			result.append(line)
		}
		return result
	}

	func trim(_ lines: inout [Line]) {
		guard !lines.isEmpty else {
			return
		}

		guard let min = lines.min(by: \.indent) else {
			return
		}

		for index in 0..<lines.count {
			lines[index].indent = lines[index].indent - min
		}
	}

	func normalize(_ lines: inout [Line]) {

		var current: Int = -1

		for index in 0..<lines.count {

			let max = current + 1

			let indent = lines[index].indent
			lines[index].indent = min(indent, max)

			current = min(indent, max)
		}
	}

	func removePrefix(_ lines: inout [Line]) {
		for index in 0..<lines.count {
			let text = lines[index].text
			if let prefix = text.first, Prefix.all.contains(prefix) {
				lines[index].text = String(text.dropFirst()).trimmingCharacters(in: .whitespaces)
			}
		}
	}
}

// MARK: - Nested data structs
private extension TextParser {

	struct Line {
		var indent: Int
		var text: String
	}

	enum Prefix: Character {
		case asterisk = "*"
		case dash = "-"

		static var all: Set<Character> = ["*", "-"]
	}
}
