//
//  ListSnapshot.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Foundation

struct ListSnapshot<Element: Identifiable> {

	var items: [Element]

	// MARK: - Cache

	private(set) var cache: [Element.ID: Int] = [:]


	init(items: [Element]) {
		self.items = items
		for i in 0..<items.count {
			let id = items[i].id
			cache[id] = i
		}
	}
}
