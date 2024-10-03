//
//  AppDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		configureMenu()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}

}

// MARK: - Helpers
private extension AppDelegate {

	func configureMenu() {

		let menu = NSMenu(title: "Main")
		menu.addItem(MenuBuilder.Item.plan.makeItem())
		menu.addItem(MenuBuilder.Item.file.makeItem())
		menu.addItem(MenuBuilder.Item.edit.makeItem())
		menu.addItem(MenuBuilder.Item.editor.makeItem())
		menu.addItem(MenuBuilder.Item.view.makeItem())

		let windowMenuItem = MenuBuilder.Item.window.makeItem()
		menu.addItem(windowMenuItem)

		NSApp.windowsMenu = windowMenuItem.submenu
		NSApp.mainMenu = menu
	}
}
