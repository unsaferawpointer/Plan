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

		let menu = MenuBuilder.makeMenu(
			withTitle: "Main",
			for:
				[
					.plan,
					.file,
					.edit,
					.editor,
					.view,
					.window
				]
		)
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
