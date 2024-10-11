//
//  HierarchyStringPresenter.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 18.11.2023.
//

import Foundation

protocol HierarchyStringPresenterProtocol {
	func string(for node: TransferNode) -> String
}

final class HierarchyStringPresenter {

	var prefixStyle: PrefixStyle = .dash
}

// MARK: - HierarchyStringPresenterProtocol
extension HierarchyStringPresenter: HierarchyStringPresenterProtocol {

	func string(for node: TransferNode) -> String {
		return string(for: node, identation: 0)
	}
}

// MARK: - Helpers
extension HierarchyStringPresenter {

	func string(for node: TransferNode, identation: Int) -> String {

		var result = prefixStyle.symbol + " " + node.value.text

		enumerate(node: node) { current, identation in
			let prefix = Array(repeating: "\t", count: identation)
				.joined(separator: "")
			let line =  prefix + prefixStyle.symbol + " " + current.value.text
			result.append(line + "\n")
		}

		return result
	}

	func enumerate(node: TransferNode, indentation: Int = 0, block: (TransferNode, Int) -> Void) {
		print("identation = \(indentation)")
		block(node, indentation)
		node.children.forEach {
			enumerate(node: $0, indentation: indentation + 1, block: block)
		}
	}
}

enum PrefixStyle {
	case asterics
	case point
	case dash
	case nothing
}

extension PrefixStyle {

	var symbol: String {
		switch self {
		case .asterics:
			return "*"
		case .point:
			return ""
		case .dash:
			return "-"
		case .nothing:
			return ""
		}
	}
}
