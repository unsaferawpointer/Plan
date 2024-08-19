//
//  DroppedData.swift
//  Plan
//
//  Created by Anton Cherkasov on 18.08.2024.
//

import AppKit

struct DropInfo {

	var items: [Item] = []
}

// MARK: - Nested data structs
extension DropInfo {

	struct Item {
		var data: [Identifier: Data]
	}

	enum Identifier: String {
		case item
		case string
		case id
	}
}

// MARK: - Comptuted properties
extension DropInfo.Identifier {

	var type: NSPasteboard.PasteboardType {
		switch self {
		case .item:			.item
		case .string:		.string
		case .id:			.id
		}
	}
}
