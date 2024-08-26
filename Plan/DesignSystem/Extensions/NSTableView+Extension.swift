//
//  NSTableView+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

extension NSTableView {

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
