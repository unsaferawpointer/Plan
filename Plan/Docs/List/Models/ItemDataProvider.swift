//
//  PasterboardDataProvider.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 12.11.2023.
//

import Foundation

protocol ItemDataProvider {
	func makeData(for id: UUID, in items: Node<ItemContent>) -> Data
}

final class HierarchyItemDataProvider: ItemDataProvider {

	func makeData(for id: UUID, in items: Node<ItemContent>) -> Data {
		return .init()
	}
}
