//
//  DroppedData.swift
//  Plan
//
//  Created by Anton Cherkasov on 18.08.2024.
//

import AppKit

struct PasteboardInfo {

	var items: [Item] = []
}

// MARK: - Nested data structs
extension PasteboardInfo {

	struct Item {
		var data: [`Type`: Data]
	}

	enum `Type`: String {
		case item
		case string
		case id
	}
}

// MARK: - Comptuted properties
extension PasteboardInfo.`Type` {

	var value: NSPasteboard.PasteboardType {
		switch self {
		case .item:			.item
		case .string:		.string
		case .id:			.id
		}
	}
}
