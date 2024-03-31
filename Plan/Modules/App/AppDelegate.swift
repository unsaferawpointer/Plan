//
//  AppDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 14.01.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

	var coordinator = Coordinator()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		coordinator.start()
		NSApplication.shared.menu = makeMenu()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}

private extension AppDelegate {

	func makeMenu() -> NSMenu {
		let action = #selector(MenuSupportable.menuItemHasBeenClicked(_:))

		let appItem = MenuBuilder.makeItem(.main, target: self, action: action)
		let fileItem = MenuBuilder.makeItem(.file, target: nil, action: action)
		let editItem = MenuBuilder.makeItem(.edit, target: nil, action: action)

		return NSMenu(items: [appItem, fileItem, editItem])
	}
}

// MARK: - MenuSupportable
extension AppDelegate: MenuSupportable {

	func menuItemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? MenuItem.Identifier else {
			return
		}
		switch id {
		case .quit:
			coordinator.quit()
		case .about:
			coordinator.showAboutPanel()
		default:
			break
		}
	}
}

// MARK: - NSMenuItemValidation
extension AppDelegate: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let id = menuItem.representedObject as? MenuItem.Identifier else {
			return false
		}

		switch id {
		case .main, .about, .quit:
			return true
		default:
			return false
		}
	}
}

extension MenuItem.Identifier {

	static let quit: MenuItem.Identifier = .basic("quit")

	static let about: MenuItem.Identifier = .basic("about")

	static let main: MenuItem.Identifier = .basic("main")

	static let file: MenuItem.Identifier = .basic("file")

	static let editor: MenuItem.Identifier = .basic("editor")
}
