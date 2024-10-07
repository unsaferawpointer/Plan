//
//  MenuBuilder+Item.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

extension MenuBuilder {

	enum Item {

		// MARK: - Main

		case plan
		case file
		case edit
		case editor
		case view
		case window

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
		case priority
		case completed

		// MARK: - View

		case toggleToolbar
		case customizeToolbar
		case enterFullScreen

		// MARK: - Window

		case minimize
		case bringAllToFront

		// MARK: - Other

		case setEstimation

		case setIcon

		case iconColor

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
				keyEquivalent: "t"
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
		case .priority:
			let main = NSMenuItem(
				title: String(localized: "priority_item", table: "Menu"),
				action: nil,
				keyEquivalent: ""
			)
			main.identifier = .priorityMenuItem
			main.submenu = NSMenu()

			for priority in ItemPriority.allCases {
				let item = NSMenuItem(
					title: priority.title,
					action: #selector(MenuSupportable.setPriority(_:)),
					keyEquivalent: ""
				)
				item.identifier = .setPriorityMenuItem
				item.tag = priority.rawValue
				main.submenu?.addItem(item)
			}
			return main
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
					iconItem.title = icon.systemName
					iconItem.representedObject = icon
					iconItem.action = #selector(MenuSupportable.setIcon(_:))
					iconItem.image = NSImage(systemSymbolName: icon.systemName, accessibilityDescription: nil)

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
				title: String(localized: "about_item \(appName ?? "Plan")", table: "Menu"),
				action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .hide:

			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem(
				title: String(localized: "hide_item \(appName ?? "Plan")", table: "Menu"),
				action: #selector(NSApplication.hide(_:)),
				keyEquivalent: "h"
			)
			// TODO: - Add user identifier && localization
			return item
		case .hideOther:
			let item = NSMenuItem(
				title: String(localized:"hide_others_item", table: "Menu"),
				action: #selector(NSApplication.hideOtherApplications(_:)),
				keyEquivalent: "h"
			)
			item.keyEquivalentModifierMask = [.command, .option]
			// TODO: - Add user identifier && localization
			return item
		case .showAll:
			let item = NSMenuItem(
				title: String(localized: "item_show_all", table: "Menu"),
				action: #selector(NSApplication.unhideAllApplications(_:)),
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .quit:

			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem(
				title: String(localized: "quit_item \(appName ?? "Plan")", table: "Menu"),
				action: #selector(NSApplication.terminate(_:)),
				keyEquivalent: "q"
			)

			// TODO: - Add user identifier && localization
			return item
		case .newDocument:
			let item = NSMenuItem(
				title: String(localized: "new_document_item", table: "Menu"),
				action: #selector(NSDocumentController.newDocument(_:)),
				keyEquivalent: "n"
			)
			item.identifier = NSUserInterfaceItemIdentifier(rawValue: "new-menu-item")
			// TODO: - Add user identifier && localization
			return item
		case .openRecent:
			let item = NSMenuItem(
				title: String(localized: "open_recent_item", table: "Menu"),
				action: nil,
				keyEquivalent: ""
			)

			item.submenu = OpenRecentMenu(title: String(localized: "Open Recent", table: "Menu"))

			// TODO: - Add user identifier && localization
			return item
		case .open:
			let item = NSMenuItem(
				title: String(localized: "open_item", table: "Menu"),
				action: #selector(NSDocumentController.openDocument(_:)),
				keyEquivalent: "o"
			)
			// TODO: - Add user identifier && localization
			return item
		case .close:
			let item = NSMenuItem(
				title: String(localized: "close_item", table: "Menu"),
				action: #selector(NSPopover.performClose(_:)),
				keyEquivalent: "w"
			)
			// TODO: - Add user identifier && localization
			return item
		case .save:
			let item = NSMenuItem(
				title: String(localized: "save_item", table: "Menu"),
				action: #selector(NSDocument.save(_:)),
				keyEquivalent: "s"
			)
			// TODO: - Add user identifier && localization
			return item
		case .saveAs:
			let item = NSMenuItem(
				title: String(localized: "save_as_item", table: "Menu"),
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
				title: String(localized: "undo_item", table: "Menu"),
				action: .undo,
				keyEquivalent: "z"
			)
			// TODO: - Add user identifier && localization
			return item
		case .redo:
			let item = NSMenuItem(
				title: String(localized: "redo_item", table: "Menu"),
				action: .redo,
				keyEquivalent: "Z"
			)
			// TODO: - Add user identifier && localization
			return item
		case .selectAll:
			let item = NSMenuItem(
				title: String(localized: "select_all_item", table: "Menu"),
				action: .selectAll,
				keyEquivalent: "a"
			)
			// TODO: - Add user identifier && localization
			return item
		case .fold:
			let item = NSMenuItem(
				title: String(localized: "fold_item", table: "Menu"),
				action: .fold,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .unfold:
			let item = NSMenuItem(
				title: String(localized: "unfold_item", table: "Menu"),
				action: .unfold,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .toggleToolbar:
			let item = NSMenuItem(
				title: String(localized: "toggle_toolbar_shown_item", table: "Menu"),
				action: .toggleToolbarShown,
				keyEquivalent: "t"
			)
			item.keyEquivalentModifierMask = [.command, .option]
			// TODO: - Add user identifier && localization
			return item
		case .customizeToolbar:
			let item = NSMenuItem(
				title: String(localized: "сustomize_toolbar_item", table: "Menu"),
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
				title: String(localized: "minimize_item", table: "Menu"),
				action: .performMiniaturize,
				keyEquivalent: "m"
			)
			// TODO: - Add user identifier && localization
			return item
		case .bringAllToFront:
			let item = NSMenuItem(
				title: String(localized: "bring_all_to_front_item", table: "Menu"),
				action: .arrangeInFront,
				keyEquivalent: ""
			)
			// TODO: - Add user identifier && localization
			return item
		case .file:
			let item = NSMenuItem()
			item.title = String(localized: "file_item", table: "Menu")
			item.identifier = NSUserInterfaceItemIdentifier(rawValue: "file-menu-item")

			item.submenu = MenuBuilder.makeMenu(
				withTitle: String(localized: "file_item", table: "Menu"),
				for:
					[
						.newDocument,
						.open,
						.openRecent,
						.separator,
						.close,
						.save,
						.saveAs,
						.revert
					]
			)
			return item
		case .edit:
			let item = NSMenuItem()
			item.title = String(localized: "edit_item", table: "Menu")

			item.submenu = MenuBuilder.makeMenu(
				withTitle: String(localized: "edit_item", table: "Menu"),
				for:
					[
						.undo,
						.redo,
						.separator,
						.cut,
						.copy,
						.paste,
						.separator,
						.selectAll
					]
			)
			return item
		case .editor:
			let item = NSMenuItem()
			item.title = String(localized: "editor_item", table: "Menu")

			item.submenu = MenuBuilder.makeMenu(
				withTitle: String(localized: "editor_item", table: "Menu"),
				for:
					[
						.newItem,
						.separator,
						.fold,
						.unfold,
						.separator,
						.favorite,
						.completed,
						.separator,
						.delete

					]
			)
			return item
		case .view:
			let item = NSMenuItem()
			item.title = String(localized: "view_item", table: "Menu")

			item.submenu = MenuBuilder.makeMenu(
				withTitle: String(localized: "view_item", table: "Menu"),
				for:
					[
						.toggleToolbar,
						.customizeToolbar,
						.separator,
						.enterFullScreen

					]
			)
			return item
		case .window:
			let item = NSMenuItem()
			item.title = String(localized: "window_item", table: "Menu")

			item.submenu = MenuBuilder.makeMenu(
				withTitle: String(localized: "window_item", table: "Menu"),
				for:
					[
						.minimize,
						.bringAllToFront

					]
			)
			return item
		case .plan:

			let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String

			let item = NSMenuItem()
			item.title = appName ?? "Plan"

			item.submenu = MenuBuilder.makeMenu(
				withTitle: appName ?? "Plan",
				for:
					[
						.about,
						.separator,
						.hide,
						.hideOther,
						.showAll,
						.separator,
						.quit
					]
			)
			return item
		case .iconColor:
			let main = NSMenuItem(
				title: String(localized: "icon_color_item", table: "Menu"),
				action: nil,
				keyEquivalent: ""
			)
			main.identifier = .iconColorMenuItem
			main.submenu = NSMenu()

			let none = NSMenuItem(
				title: "None",
				action: #selector(MenuSupportable.setColor(_:)),
				keyEquivalent: ""
			)
			none.identifier = .setIconColorMenuItem
			none.tag = -1
			main.submenu?.addItem(none)

			main.submenu?.addItem(.separator())

			for color in Color.allCases {
				let item = NSMenuItem(
					title: color.displayName,
					action: #selector(MenuSupportable.setColor(_:)),
					keyEquivalent: ""
				)
				item.identifier = .setEstimationMenuItem
				item.tag = color.rawValue
				item.image = NSImage(systemSymbolName: "circle.fill")?
					.withSymbolConfiguration(.init(paletteColors: [color.colorValue]))
				main.submenu?.addItem(item)
			}
			return main
		}
	}
}

extension ItemPriority {

	var title: String {
		switch self {
		case .low:
			return String(localized: "low", table: "Menu")
		case .medium:
			return String(localized: "medium", table: "Menu")
		case .high:
			return String(localized: "high", table: "Menu")
		}
	}
}
