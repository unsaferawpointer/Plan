//
//  AppDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

	var menu: NSMenu?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		let menu = NSMenu()
		menu.addItem(buildPlan())
		menu.addItem(buildFile())
		menu.addItem(buildEdit())
		menu.addItem(buildEditor())
		menu.addItem(buildView())
		menu.addItem(buildWindow())

		self.menu = menu

		NSApp.mainMenu = menu
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}

}

// MARK: - Main menu support
extension AppDelegate {

	func buildPlan() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "Plan"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "Plan",
			for:
				[
					.about,
					.separator,
					.hide,
					.hideOther,
					.showAll
				]
		)
		return item
	}

	func buildFile() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "File"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "File",
			for:
				[
					.newDocument,
					.open,
					.separator,
					.close,
					.save,
					.saveAs,
					.revert
				]
		)
		return item
	}

	func buildEdit() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "Edit"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "Edit",
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
	}

	func buildEditor() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "Editor"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "Editor",
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
	}

	func buildView() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "View"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "View",
			for:
				[
					.showToolbar,
					.customizeToolbar,
					.separator,
					.enterFullScreen

				]
		)
		return item
	}

	func buildWindow() -> NSMenuItem {
		let item = NSMenuItem()
		item.title = "Window"

		item.submenu = MenuBuilder.makeMenu(
			withTitle: "Window",
			for:
				[
					.minimize,
					.bringAllToFront

				]
		)
		return item
	}
}

extension NSMenuItem {

	func modificated(_ block: (NSMenuItem) -> Void) -> NSMenuItem {
		block(self)
		return self
	}
}
