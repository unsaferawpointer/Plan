//
//  OpenRecentMenu.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.09.2024.
//

import Cocoa

final class OpenRecentMenu: NSMenu {

	// MARK: - DI

	var documentController: DocumentControllerFacadeProtocol

	var workspace: WorkspaceFacadeProtocol

	// MARK: - Initialization

	init(
		title: String,
		documentController: DocumentControllerFacadeProtocol = DocumentController(),
		workspace: WorkspaceFacadeProtocol = WorkspaceFacade()
	) {
		self.documentController = documentController
		self.workspace = workspace
		super.init(title: title)
		self.delegate = self
	}

	@available(*, unavailable, message: "init(coder:) has not been implemented")
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - NSMenuDelegate
extension OpenRecentMenu: NSMenuDelegate {

	func menuWillOpen(_ menu: NSMenu) {
		menu.items.removeAll()

		var count = 0
		for url in NSDocumentController.shared.recentDocumentURLs {
			let menuItem = NSMenuItem(
				title: url.lastPathComponent,
				action: #selector(openRecentFile(_:)),
				keyEquivalent: ""
			)
			menuItem.target = self
			menuItem.representedObject = url
			menuItem.tag = count
			let image = workspace.image(forFile: url)
			image.size = NSSize(width: 16, height: 16)
			menuItem.image = image
			menu.addItem(menuItem)
			count += 1
		}
		let clearItem = NSMenuItem(
			title: "Clear Menu",
			action: #selector(NSDocumentController.clearRecentDocuments(_:)),
			keyEquivalent: ""
		)
		if count > 0 {
			menu.addItem(NSMenuItem.separator())
		} else {
			clearItem.isEnabled = false
		}
		menu.addItem(clearItem)
	}
}

// MARK: - Actions
extension OpenRecentMenu {

	@objc
	func openRecentFile(_ sender: NSMenuItem?) {
		guard let url = sender?.representedObject as? URL else {
			return
		}

		documentController.openRecentFile(withContentsOf: url)
	}
}
