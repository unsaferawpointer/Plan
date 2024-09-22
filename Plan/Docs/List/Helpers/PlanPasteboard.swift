//
//  PlanPasteboard.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.09.2024.
//

import AppKit

protocol PlanPasteboardProtocol {
	func write(_ nodes: [any TreeNode<ItemContent>], to pasteboard: PasteboardFacadeProtocol, clearContents: Bool)
	func readNodes(from pasteboard: PasteboardFacadeProtocol) -> [any TreeNode<ItemContent>]
	func readTexts(from pasteboard: PasteboardFacadeProtocol) -> [String]
	func contains(types: Set<PasteboardInfo.`Type`>, in pasteboard: PasteboardFacadeProtocol) -> Bool
}

final class PlanPasteboard {

	private var formatter: BasicFormatterProtocol

	// MARK: - Initialization

	init(formatter: BasicFormatterProtocol = BasicFormatter()) {
		self.formatter = formatter
	}
}

// MARK: - PlanPasteboardProtocol
extension PlanPasteboard: PlanPasteboardProtocol {

	func write(_ nodes: [any TreeNode<ItemContent>], to pasteboard: PasteboardFacadeProtocol, clearContents: Bool) {

		// Cache
		let identifiers = Set(nodes.map { $0.value.id} )

		let encoder = JSONEncoder()

		let items = nodes.map { node in
			var transferNode = makeNode(node)
			transferNode.delete(identifiers)

			var dictionary: [PasteboardInfo.`Type`: Data] = [:]

			if let textData = formatter.format(transferNode).data(using: .utf8) {
				dictionary[.string] = textData
			}
			if let itemData = try? encoder.encode(transferNode) {
				dictionary[.item] = itemData
			}

			return PasteboardInfo.Item(data: dictionary)
		}

		let info = PasteboardInfo(items: items)

		pasteboard.setInfo(info, clearContents: clearContents)
	}

	func readTexts(from pasteboard: PasteboardFacadeProtocol) -> [String] {
		guard let info = pasteboard.info(for: [.string]) else {
			return []
		}
		return info.items.map(\.data).compactMap {
			$0[.item]
		}.compactMap {
			String(data: $0, encoding: .utf8)
		}
	}

	func readNodes(from pasteboard: PasteboardFacadeProtocol) -> [any TreeNode<ItemContent>] {

		guard let info = pasteboard.info(for: [.item, .string]) else {
			return []
		}

		// Item
		let nodesData = info.items.compactMap {
			$0.data[.item]
		}

		return nodesData
			.compactMap { $0 }
			.compactMap {
			try? JSONDecoder().decode(TransferNode.self, from: $0)
		}
	}

	func contains(types: Set<PasteboardInfo.`Type`>, in pasteboard: PasteboardFacadeProtocol) -> Bool {
		pasteboard.contains([.string, .item])
	}
}

// MARK: - PlanPasteboard
private extension PlanPasteboard {

	func makeNode(_ entity: any TreeNode<ItemContent>) -> TransferNode {
		return TransferNode(value: entity.value, children: entity.children.map({ node in
			makeNode(node)
		}))
	}
}
