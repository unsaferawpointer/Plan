//
//  MenuSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
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

}
