//
//  SidebarContextMenu.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.02.2024.
//

import Cocoa

final class SidebarContextMenu: NSMenu {

	weak var menuDelegate: MenuDelegate?

	private var localization: SidebarMenuLocalizationProtocol

	init(delegate: MenuDelegate, localization: SidebarMenuLocalizationProtocol) {
		self.menuDelegate = delegate
		self.localization = localization
		super.init(title: "")
		configureItems()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Helpers
private extension SidebarContextMenu {

	func configureItems() {

		let action = #selector(itemHasBeenClicked(_:))

		let newList = MenuBuilder.makeItem(.newList, target: self, action: action)
		let deleteList = MenuBuilder.makeItem(.delete, target: self, action: action)

		addItem(newList)
		addItem(.separator())
		addItem(deleteList)
	}
}

// MARK: - Actions
extension SidebarContextMenu {

	@objc
	func itemHasBeenClicked(_ sender: NSMenuItem) {
		print(#function)
		guard let id = sender.representedObject as? MenuItem.Identifier else {
			return
		}
		menuDelegate?.menuItemHasBeenClicked(id)
	}
}

// MARK: - NSMenuItemValidation
extension SidebarContextMenu: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let id = menuItem.representedObject as? MenuItem.Identifier, let menuDelegate else {
			return false
		}
		return menuDelegate.validateMenuItem(id)
	}
}

extension MenuItem.Identifier {

	static let newList: MenuItem.Identifier = .basic("newList")
}

