//
//  NSOutlineView+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import Cocoa

extension NSOutlineView {

	static var inset: NSOutlineView {
		let view = NSOutlineView()
		view.style = .inset
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = false
		view.usesAutomaticRowHeights = false
		view.indentationPerLevel = 24
		return view
	}
}

extension NSOutlineView {

	func selectedIdentifiers() -> [UUID] {
		return effectiveSelection().compactMap {
			item(atRow: $0) as? ListItem
		}
		.map(\.uuid)
	}
}
