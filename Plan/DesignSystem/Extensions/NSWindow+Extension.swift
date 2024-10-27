//
//  NSWindow+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 15.10.2024.
//

import Cocoa

extension NSWindow {

	static func makeMain() -> NSWindow {
		let window = NSWindow()
		window.minSize = .init(width: 640, height: 480)
		window.styleMask = [
			.miniaturizable,
			.closable,
			.resizable,
			.titled,
			.fullSizeContentView,
			.unifiedTitleAndToolbar
		]
		window.isRestorable = true
		window.center()
		window.titleVisibility = .visible
		window.titlebarAppearsTransparent = false
		window.tabbingMode = .automatic
		window.titlebarSeparatorStyle = .automatic
		window.toolbarStyle = .unified
		return window
	}
}
