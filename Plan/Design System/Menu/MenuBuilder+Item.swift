//
//  MenuBuilder+Item.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Cocoa

extension MenuBuilder {

	enum Item {

		case new
		case delete

		case favorite
		case completed

		case separator
	}
}

extension MenuBuilder.Item {

	func makeItem() -> NSMenuItem {
		switch self {
		case .new:
			let item = NSMenuItem(
				title: "New",
				action: #selector(MenuSupportable.createNew),
				keyEquivalent: "n"
			)
			item.identifier = .newMenuItem
			return item
		case .delete:
			let item = NSMenuItem(
				title: "Delete",
				action: #selector(MenuSupportable.delete),
				keyEquivalent: "\u{0008}"
			)
			item.identifier = .deleteMenuItem
			return item
		case .separator:
			return .separator()
		case .favorite:
			let item = NSMenuItem(
				title: "Bookmark",
				action: #selector(MenuSupportable.toggleBookmark(_:)),
				keyEquivalent: "b"
			)
			item.identifier = .bookmarkMenuItem
			return item
		case .completed:
			let item = NSMenuItem(
				title: "Completed",
				action: #selector(MenuSupportable.toggleCompleted(_:)),
				keyEquivalent: "\r"
			)
			item.identifier = .setStatusMenuItem
			return item
		}
	}
}
