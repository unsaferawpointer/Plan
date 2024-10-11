//
//  TransferItem.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 11.11.2023.
//

import Foundation

struct TransferNode: TreeNode {

	var value: ItemContent

	var children: [TransferNode]
}

// MARK: - Codable
extension TransferNode: Codable { }

extension TransferNode {

	mutating func delete(_ ids: Set<UUID>) {
		children.removeAll {
			ids.contains($0.value.id)
		}
		for index in 0..<children.count {
			children[index].delete(ids)
		}
	}
}
