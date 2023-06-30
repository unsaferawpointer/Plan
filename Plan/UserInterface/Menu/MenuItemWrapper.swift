//
//  MenuItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.06.2023.
//

import Cocoa

final class MenuItemWrapper: NSMenuItem {

	let model: MenuItem

	// MARK: - Initialization

	init(model: MenuItem) {
		self.model = model
		super.init(
			title: model.title,
			action: #selector(menuHasBeenClicked(_:)),
			keyEquivalent: model.keyEquivalent)
		image = NSImage(systemSymbolName: model.iconName)
		self.target = self
	}

	@available(*, unavailable, message: "Use init(model:)")
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Actions
extension MenuItemWrapper {

	@objc
	func menuHasBeenClicked(_ sender: Any) {
		model.action()
	}
}
