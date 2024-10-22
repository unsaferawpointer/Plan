//
//  TableColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

protocol TableColumn<RowModel> {

	associatedtype CellModel

	associatedtype RowModel: Identifiable

	associatedtype Cell: TableCell where Cell.Model == CellModel

	var keyPath: KeyPath<RowModel, CellModel> { get }

	var identifier: String { get }

	var title: String { get }

	var options: TableColumnOptions { get }

	var action: ((RowModel.ID, CellModel.Value) -> Void)? { get set }
}

// MARK: - Implementation by-default
extension TableColumn {

	func makeCellIfNeeded(from model: RowModel, in table: NSTableView) -> NSView? {
		let id = NSUserInterfaceItemIdentifier(Cell.reuseIdentifier)
		var view = table.makeView(withIdentifier: id, owner: self) as? Cell
		if view == nil {
			view = Cell(model[keyPath: keyPath])
			view?.identifier = id
		}
		view?.model = model[keyPath: keyPath]
		view?.action = { value in
			action?(model.id, value)
		}
		return view
	}

	func configureCell(for model: RowModel, at row: Int, in table: NSTableView) {
		let id = NSUserInterfaceItemIdentifier(identifier)
		let cell = table.view(column: id, row: row, makeIfNecessary: false) as? Cell
		cell?.model = model[keyPath: keyPath]
	}
}

struct TableColumnOptions {

	let minWidth: CGFloat?

	let maxWidth: CGFloat?

	var isRequired: Bool

	var isHidden: Bool
}
