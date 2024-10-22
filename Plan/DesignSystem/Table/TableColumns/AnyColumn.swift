//
//  AnyColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.08.2024.
//

import Foundation

struct AnyColumn<RowModel: Identifiable, Cell: TableCell>: TableColumn {

	typealias CellModel = Cell.Model

	var identifier: String
	
	var title: String
	
	var keyPath: KeyPath<RowModel, CellModel>

	var options: TableColumnOptions

	var action: ((RowModel.ID, CellModel.Value) -> Void)?

	// MARK: - Initialization

	init(
		identifier: String,
		title: String,
		keyPath: KeyPath<RowModel, CellModel>,
		options: TableColumnOptions,
		action: ((RowModel.ID, CellModel.Value) -> Void)? = nil
	) {
		self.identifier = identifier
		self.title = title
		self.keyPath = keyPath
		self.options = options
		self.action = action
	}
}
