//
//  AnyColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.08.2024.
//

import Foundation

struct AnyColumn<Model: Identifiable, Cell: TableCell>: TableColumn {

	typealias Value = Cell.Model

	var identifier: String
	
	var title: String
	
	var keyPath: KeyPath<Model, Value>

	var options: TableColumnOptions

	var action: ((Model.ID, Value) -> Void)?

	// MARK: - Initialization

	init(
		identifier: String,
		title: String,
		keyPath: KeyPath<Model, Value>,
		options: TableColumnOptions,
		action: ((Model.ID, Value) -> Void)? = nil
	) {
		self.identifier = identifier
		self.title = title
		self.keyPath = keyPath
		self.options = options
		self.action = action
	}
}
