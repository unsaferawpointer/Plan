//
//  AppPage.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 23.08.2024.
//

import XCTest

final class AppPage {

	var app: XCUIApplication

	init(app: XCUIApplication) {
		self.app = app
	}
}

extension AppPage {

	func launch() {
		app.launch()
	}

	func newDoc() {
		let menuBarItem = app.menuBars.menuBarItems["file-menu-item"]
		menuBarItem.click()
		let menu = menuBarItem.menus.firstMatch
		menu.menuItems["new-menu-item"].click()
	}

	func firstWindow() -> XCUIElement {
		return app.windows.firstMatch
	}

	func windows() -> XCUIElementQuery {
		return app.windows
	}

	func closeAll() {
		while !app.windows.allElementsBoundByIndex.isEmpty {
			for window in app.windows.allElementsBoundByIndex.reversed() {
				DocumentPage(window: window).close()
			}
		}
	}

	func press(_ key: String, modifierFlags: XCUIElement.KeyModifierFlags) {
		app.typeKey(key, modifierFlags: modifierFlags)
	}
}
