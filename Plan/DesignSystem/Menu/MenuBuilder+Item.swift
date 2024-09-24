//
//  MenuBuilder+Item.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

extension MenuBuilder {

	enum Item {

		case new
		case delete

		case copy
		case cut
		case paste

		case favorite
		case completed

		case setEstimation

		case setIcon

		case separator
	}
}

extension MenuBuilder.Item {

	func makeItem() -> NSMenuItem {
		switch self {
		case .new:
			let item = NSMenuItem(
				title: String(localized: "new_item", table: "Menu"),
				action: #selector(MenuSupportable.createNew),
				keyEquivalent: "n"
			)
			item.identifier = .newMenuItem
			return item
		case .delete:
			let item = NSMenuItem(
				title: String(localized: "delete_item", table: "Menu"),
				action: #selector(MenuSupportable.delete),
				keyEquivalent: "\u{0008}"
			)
			item.image = NSImage(systemSymbolName: "trash")
			item.identifier = .deleteMenuItem
			return item
		case .separator:
			return .separator()
		case .favorite:
			let item = NSMenuItem(
				title: String(localized: "bookmarked_item", table: "Menu"),
				action: #selector(MenuSupportable.toggleBookmark(_:)),
				keyEquivalent: "b"
			)
			item.identifier = .bookmarkMenuItem
			return item
		case .completed:
			let item = NSMenuItem(
				title: String(localized: "completed_item", table: "Menu"),
				action: #selector(MenuSupportable.toggleCompleted(_:)),
				keyEquivalent: "\r"
			)
			item.identifier = .setStatusMenuItem
			return item
		case .setEstimation:
			let main = NSMenuItem(
				title: String(localized: "number_item", table: "Menu"),
				action: nil,
				keyEquivalent: ""
			)
			main.identifier = .numberMenuItem
			main.submenu = NSMenu()

			let none = NSMenuItem(
				title: "None",
				action: #selector(MenuSupportable.setEstimation(_:)),
				keyEquivalent: "0"
			)
			none.identifier = .setEstimationMenuItem
			none.tag = 0
			main.submenu?.addItem(none)

			main.submenu?.addItem(.separator())

			for (index, number) in [1, 2, 3, 4, 5, 6, 7, 8, 9].enumerated() {
				let item = NSMenuItem(
					title: "\(number)",
					action: #selector(MenuSupportable.setEstimation(_:)),
					keyEquivalent: "\(index + 1)"
				)
				item.identifier = .setEstimationMenuItem
				item.tag = number
				main.submenu?.addItem(item)
			}
			return main
		case .setIcon:
			let main = NSMenuItem(
				title: String(localized: "icon_item", table: "Menu"),
				action: nil,
				keyEquivalent: ""
			)
			main.identifier = .iconMenuItem
			main.submenu = NSMenu()

			let none = NSMenuItem(
				title: String(localized: "none_item", table: "Menu"),
				action: #selector(MenuSupportable.setIcon(_:)),
				keyEquivalent: ""
			)
			none.identifier = .setIconMenuItem
			main.submenu?.addItem(none)

			main.submenu?.addItem(.separator())

			for category in IconCategory.allCases {

				let item = NSMenuItem()
				item.submenu = NSMenu()
				item.title = category.displayName
				item.identifier = .iconsGroupMenuItem

				for icon in category.icons {

					let iconItem = NSMenuItem()
					iconItem.identifier = .setIconMenuItem
					iconItem.title = icon.rawValue
					iconItem.representedObject = icon
					iconItem.action = #selector(MenuSupportable.setIcon(_:))
					iconItem.image = NSImage(systemSymbolName: icon.rawValue, accessibilityDescription: nil)

					item.submenu?.addItem(iconItem)
				}
				main.submenu?.addItem(item)
			}
			return main
		case .copy:
			let item = NSMenuItem(
				title: String(localized: "copy_item", table: "Menu"),
				action: #selector(MenuSupportable.copy(_:)),
				keyEquivalent: "c"
			)
			item.identifier = .copyMenuItem
			return item
		case .paste:
			let item = NSMenuItem(
				title: String(localized: "paste_item", table: "Menu"),
				action: #selector(MenuSupportable.paste(_:)),
				keyEquivalent: "v"
			)
			item.identifier = .pasteMenuItem
			return item
		case .cut:
			let item = NSMenuItem(
				title: String(localized: "cut_item", table: "Menu"),
				action: #selector(MenuSupportable.cut(_:)),
				keyEquivalent: "x"
			)
			item.identifier = .cutMenuItem
			return item
		}
	}
}
