//
//  TodosTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import AppKit

final class TodosTableAdapter: NSObject {

	weak var table: NSTableView?

	// MARK: - Data

	private (set) var items: [TodoModel] = []

	var selection: (([UUID]) -> Void)?

	var textfieldDidChange: ((String, UUID) -> Void)?

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
			self?.textfieldDidChange?(newValue, model.uuid)
		}

		return view
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
		selection?(ids)
	}
}
