//
//  TableColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

protocol TableColumn<Model> {

	associatedtype Value

	associatedtype Model: Identifiable

	associatedtype Cell: TableCell where Cell.Model == Value

	var keyPath: KeyPath<Model, Value> { get }

	var identifier: String { get }

	var title: String { get }

	var action: ((Model.ID, Value) -> Void)? { get set }
}

// MARK: - Implementation by-default
extension TableColumn {

	func makeCellIfNeeded(from model: Model, in table: NSTableView) -> NSView? {
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

	func configureCell(for model: Model, at row: Int, in table: NSTableView) {
		let id = NSUserInterfaceItemIdentifier(identifier)
		let cell = table.view(column: id, row: row, makeIfNecessary: false) as? Cell
		cell?.model = model[keyPath: keyPath]
	}
}
