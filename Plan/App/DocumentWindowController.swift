//
//  DocumentWindowController.swift
//  Plan
//
//  Created by Anton Cherkasov on 15.10.2024.
//

import Cocoa

class DocumentWindowController: NSWindowController {

	// MARK: - Initialization block

	override init(window: NSWindow?) {
		super.init(window: window)
		configureToolbar()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

// MARK: - Helpers
private extension DocumentWindowController {

	func configureToolbar() {
		guard let window else {
			return
		}

		let toolbar = NSToolbar.init(identifier: "document_toolbar")
		toolbar.delegate = self
		toolbar.allowsUserCustomization = true
		toolbar.autosavesConfiguration = true
		toolbar.displayMode = .iconOnly

		window.toolbarStyle = .unified
		window.toolbar = toolbar
		window.toolbar?.validateVisibleItems()
	}
}

// MARK: - NSToolbarDelegate
extension DocumentWindowController: NSToolbarDelegate {

	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.flexibleSpace, .newItem]
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.flexibleSpace, .newItem]
	}

	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		switch itemIdentifier {
		case .newItem:
			let item = NSToolbarItem(itemIdentifier: .newItem)
			item.label = String(localized: "new_item_toolbar_item", table: "AppLocalizable")

			let button = NSButton(
				title: "",
				image: NSImage(systemSymbolName: "plus")!,
				target: self,
				action: #selector(newItem(_:))
			)
			button.setAccessibilityIdentifier("new-toolbar-item")
			button.identifier = NSUserInterfaceItemIdentifier("new-toolbar-item")
			button.bezelStyle = .texturedRounded

			item.view = button
			return item
		default:
			return nil
		}
	}
}

// MARK: - Actions
extension DocumentWindowController {

	@objc
	func newItem(_ sender: Any?) {
		NotificationCenter.default.post(name: .newItem, object: nil)
	}

}

extension NSToolbarItem.Identifier {

	static var newItem: Self {
		return .init("newItem")
	}

}

extension NSNotification.Name {

	static let newItem: NSNotification.Name = .init("newItem")
}
