//
//  NSWindow+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

extension NSWindow {

	static func makeDefault() -> NSWindow {
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
		window.setFrameAutosaveName("main_window")
		window.titleVisibility = .visible
		window.titlebarAppearsTransparent = false
		window.toolbarStyle = .unified
		window.titlebarSeparatorStyle = .automatic
		window.identifier = .init("main_window")
		return window
	}
}
