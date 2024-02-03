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

		table?.menu = makeContextMenu()
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

// MARK: - Menu support
extension TodosTableAdapter {

	func validateMenuItem(_ itemIdentifier: NSUserInterfaceItemIdentifier) -> Bool {
		guard let rows = table?.effectiveSelection() else {
			return false
		}

		switch itemIdentifier {
		case .newMenuItem:
			return true
		case .bookmarkMenuItem, .setStatusMenuItem, .deleteMenuItem:
			return !rows.isEmpty
		default:
			return false
		}
	}

	func menuItemState(for itemIdentifier: NSUserInterfaceItemIdentifier) -> NSControl.StateValue {
		guard let rows = table?.effectiveSelection() else {
			return .off
		}

		var hasEnabled = false
		var hasDisabled = false

		for row in rows {

			var state = false

			switch itemIdentifier {
			case .bookmarkMenuItem:
				state = items[row].isFavorite
			case .setStatusMenuItem:
				state = items[row].isDone
			default:
				state = false
			}

			switch state {
			case false:	hasDisabled = true
			case true:	hasEnabled = true
			}
		}

		if hasEnabled && hasDisabled {
			return .mixed
		} else if hasEnabled {
			return .on
		} else {
			return .off
		}
	}
}

private extension TodosTableAdapter {

	func makeContextMenu() -> NSMenu {
		return MenuBuilder.makeMenu(
			withTitle: "",
			for:
				[
					.new,
					.separator,
					.favorite,
					.completed,
					.separator,
					.delete
				]
		)
	}
}
