//
//  MenuSupportable.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

@objc
protocol MenuSupportable {

	@objc
	optional func createNew(_ sender: NSMenuItem)

	@objc
	optional func delete(_ sender: NSMenuItem)

	@objc
	optional func toggleCompleted(_ sender: NSMenuItem)

	@objc
	optional func toggleBookmark(_ sender: NSMenuItem)

	@objc
	optional func setEstimation(_ sender: NSMenuItem)

	@objc
	optional func setIcon(_ sender: NSMenuItem)

	@objc
	optional func undo(_ sender: NSMenuItem)

	@objc
	optional func redo(_ sender: NSMenuItem)

}
