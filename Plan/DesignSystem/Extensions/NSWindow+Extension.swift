//
//  NSWindow+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 15.10.2024.
//

import Cocoa

extension NSWindow {

	static let main: NSWindow = {
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
		window.tabbingMode = .preferred
		window.titlebarSeparatorStyle = .automatic
		window.toolbarStyle = .unified
		window.identifier = .init("main_window")
		return window
	}()
}
