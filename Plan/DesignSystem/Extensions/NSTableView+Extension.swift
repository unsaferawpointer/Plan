//
//  NSTableView+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

extension NSTableView {

	static var insetTable: NSTableView {
		let view = NSTableView()
		view.style = .inset
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = true
		view.usesAutomaticRowHeights = false
		return view
	}

	func effectiveSelection() -> IndexSet {
		if clickedRow != -1 {
			if selectedRowIndexes.contains(clickedRow) {
				return selectedRowIndexes
			} else {
				return IndexSet(integer: clickedRow)
			}
		} else {
			return selectedRowIndexes
		}
	}

	func view(column: NSUserInterfaceItemIdentifier, row: Int, makeIfNecessary: Bool) -> NSView? {
		guard let index = tableColumns.firstIndex(where: \.identifier, equalsTo: column) else {
			return nil
		}
		return view(atColumn: index, row: row, makeIfNecessary: makeIfNecessary)
	}
}
