//
//  MenuBuilder+Item.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

extension MenuBuilder {

	enum Item {

		// MARK: - Plan

		case about
		case hide
		case hideOther
		case showAll
		case quit

		// MARK: - File

		case newDocument
		case openRecent
		case open
		case close
		case save
		case saveAs
		case revert

		// MARK: - Edit

		case undo
		case redo
		case cut
		case copy
		case paste
		case selectAll

		// MARK: - Editor

		case newItem
		case fold
		case unfold
		case delete

		case favorite
		case completed

		// MARK: - View

		case showToolbar
		case customizeToolbar
		case enterFullScreen

		// MARK: - Window

		case minimize
		case bringAllToFront

		// MARK: - Other

		case setEstimation

		case setIcon

		case separator
	}
}

extension MenuBuilder.Item {

	func makeItem() -> NSMenuItem {
		switch self {
		case .newItem:
			let item = NSMenuItem(
				title: String(localized: "new_item", table: "Menu"),
				action: .createNew,
				keyEquivalent: "n"
			)
			item.identifier = .newMenuItem
			return item
		case .delete:
			let item = NSMenuItem(
				title: String(localized: "delete_item", table: "Menu"),
				action: .delete,
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
				action: .toggleBookmarked,
				keyEquivalent: "b"
			)
			item.identifier = .bookmarkMenuItem
			return item
		case .completed:
			let item = NSMenuItem(
				title: String(localized: "completed_item", table: "Menu"),
				action: .toggleCompleted,
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
				action: .copy,
				keyEquivalent: "c"
			)
			item.identifier = .copyMenuItem
			return item
		case .paste:
			let item = NSMenuItem(
				title: String(localized: "paste_item", table: "Menu"),
				action: .paste,
				keyEquivalent: "v"
			)
			item.identifier = .pasteMenuItem
			return item
		case .cut:
			let item = NSMenuItem(
				title: String(localized: "cut_item", table: "Menu"),
				action: .cut,
				keyEquivalent: "x"
			)
			item.identifier = .cutMenuItem
			return item
		case .about:
			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem(
				title: "About \(appName ?? "Plan")",
				action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .hide:

			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem(
				title: "Hide \(appName ?? "Plan")",
				action: #selector(NSApplication.hide(_:)),
				keyEquivalent: "h"
			)
			// TODO: - Add user identifier && localization
			return item
		case .hideOther:
			let item = NSMenuItem(
				title: "Hide Others",
				action: #selector(NSApplication.hideOtherApplications(_:)),
				keyEquivalent: "h"
			)
			item.keyEquivalentModifierMask = [.command, .option]
			// TODO: - Add user identifier && localization
			return item
		case .showAll:
			let item = NSMenuItem(
				title: "Show All",
				action: #selector(NSApplication.unhideAllApplications(_:)),
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .quit:

			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem(
				title: "Quit \(appName ?? "Plan")",
				action: #selector(NSApplication.terminate(_:)),
				keyEquivalent: "q"
			)

			// TODO: - Add user identifier && localization
			return item
		case .newDocument:
			let item = NSMenuItem(
				title: "New",
				action: #selector(NSDocumentController.newDocument(_:)),
				keyEquivalent: "n"
			)
			// TODO: - Add user identifier && localization
			return item
		case .openRecent:
			let item = NSMenuItem(
				title: "Open Recent",
				action: nil,
				keyEquivalent: ""
			)

			item.submenu = OpenRecentMenu(title: "Open Recent")

			// TODO: - Add user identifier && localization
			return item
		case .open:
			let item = NSMenuItem(
				title: "Open...",
				action: #selector(NSDocumentController.openDocument(_:)),
				keyEquivalent: "o"
			)
			// TODO: - Add user identifier && localization
			return item
		case .close:
			let item = NSMenuItem(
				title: "Close",
				action: #selector(NSPopover.performClose(_:)),
				keyEquivalent: "w"
			)
			// TODO: - Add user identifier && localization
			return item
		case .save:
			let item = NSMenuItem(
				title: "Save...",
				action: #selector(NSDocument.save(_:)),
				keyEquivalent: "s"
			)
			// TODO: - Add user identifier && localization
			return item
		case .saveAs:
			let item = NSMenuItem(
				title: "Save As...",
				action: #selector(NSDocument.saveAs(_:)),
				keyEquivalent: "S"
			)
			// TODO: - Add user identifier && localization
			return item
		case .revert:
			let item = NSMenuItem(
				title: "Revert To Saved",
				action: #selector(NSDocument.revertToSaved(_:)),
				keyEquivalent: "r"
			)
			// TODO: - Add user identifier && localization
			return item
		case .undo:
			let item = NSMenuItem(
				title: "Undo",
				action: .undo,
				keyEquivalent: "z"
			)
			// TODO: - Add user identifier && localization
			return item
		case .redo:
			let item = NSMenuItem(
				title: "Redo",
				action: .redo,
				keyEquivalent: "Z"
			)
			// TODO: - Add user identifier && localization
			return item
		case .selectAll:
			let item = NSMenuItem(
				title: "Select All",
				action: .selectAll,
				keyEquivalent: "a"
			)
			// TODO: - Add user identifier && localization
			return item
		case .fold:
			let item = NSMenuItem(
				title: "Fold",
				action: .fold,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .unfold:
			let item = NSMenuItem(
				title: "Unfold",
				action: .unfold,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .showToolbar:
			let item = NSMenuItem(
				title: "Show Toolbar",
				action: .toggleToolbarShown,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .customizeToolbar:
			let item = NSMenuItem(
				title: "Customize Toolbar…",
				action: .runToolbarCustomizationPalette,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .enterFullScreen:
			let item = NSMenuItem(
				title: "Enter Full Screen",
				action: .toggleFullScreen,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .minimize:
			let item = NSMenuItem(
				title: "Minimize",
				action: .performMiniaturize,
				keyEquivalent: "m"
			)
			// TODO: - Add user identifier && localization
			return item
		case .bringAllToFront:
			let item = NSMenuItem(
				title: "Bring All to Front",
				action: .arrangeInFront,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		}
	}
}
