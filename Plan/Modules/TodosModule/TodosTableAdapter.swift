//
//  TodosTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import AppKit

final class TodosTableAdapter: NSObject {

	weak var table: NSTableView?

	weak var output: TodosViewOutput?

	// MARK: - Data

	private (set) var items: [TodoModel] = []

	var selection: (([UUID]) -> Void)?

	// MARK: - Initialization

	init(table: NSTableView? = nil) {
		self.table = table

		super.init()

		table?.delegate = self
		table?.dataSource = self
	}
}

extension TodosTableAdapter {

	func apply(_ items: [TodoModel]) {
		self.items = items
		table?.reloadData()
	}
}

// MARK: - NSTableViewDataSource
extension TodosTableAdapter: NSTableViewDataSource {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return items.count
	}
}

// MARK: - NSTableViewDelegate
extension TodosTableAdapter: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let model = items[row]

		let id = NSUserInterfaceItemIdentifier(LabelView.userIdentifier)
		var view = table?.makeView(withIdentifier: id, owner: self) as? TodoCell
		if view == nil {
			view = TodoCell()
			view?.identifier = id
		}

		view?.configure(model)

		view?.textAction = { [weak self] newValue in
			self?.output?.textfieldDidChange(newValue, for: model.uuid)
		}
		view?.checkboxAction = { [weak self] newValue in
			self?.output?.checkboxDidChange(newValue, for: [model.uuid])
		}

		return view
	}

	func tableView(
		_ tableView: NSTableView,
		rowActionsForRow row: Int,
		edge: NSTableView.RowActionEdge
	) -> [NSTableViewRowAction] {
		guard case .trailing = edge else {
			return []
		}
		return [
			.init(style: .destructive, title: "Delete", handler: { [weak self] action, row in
				guard let self else {
					return
				}
				let item = items[row]
				self.output?.delete([item.uuid])
			})
		]
	}
}

// MARK: - Selection support
extension TodosTableAdapter {

	func tableViewSelectionDidChange(_ notification: Notification) {
		guard let rows = table?.selectedRowIndexes else {
			return
		}
		let ids = rows.compactMap { row in
			items[row].uuid
		}
		output?.selectionDidChange(ids)
	}
}
