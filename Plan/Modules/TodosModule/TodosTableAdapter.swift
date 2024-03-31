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

	private (set) var items: [TableItem] = []

	// MARK: - Initialization

	init(table: NSTableView? = nil) {
		self.table = table

		super.init()

		table?.delegate = self
		table?.dataSource = self
	}
}

// MARK: - Public interface
extension TodosTableAdapter {

	func apply(_ items: [TableItem]) {
		let selectedRows = table?.selectedRowIndexes ?? .init()
		let selectedIds = selectedRows.compactMap { row in
			self.items[row].uuid
		}
		let set = Set(selectedIds)

		let difference = items.difference(from: self.items)
		self.items = items

		table?.beginUpdates()
		for change in difference {
			switch change {
			case let .remove(oldOffset, element, newOffset):
				table?.removeRows(at: .init(integer: oldOffset), withAnimation: [.effectFade])
			case let .insert(newOffset, element, oldOffset):
				table?.insertRows(at: .init(integer: newOffset), withAnimation: [.effectFade])
			}
		}
		table?.endUpdates()

		for (index, item) in items.enumerated() {
			guard let uuid = item.uuid, set.contains(uuid) else {
				continue
			}
			table?.selectRowIndexes(.init(integer: index), byExtendingSelection: true)
		}

	}

	var selection: [UUID] {
		get {
			let rows = table?.effectiveSelection() ?? .init()
			return rows.compactMap { row in
				items[row].uuid
			}
		}
	}

	func focusOn(id: UUID) {
		guard
			let firstIndex = items.firstIndex(where: { $0.uuid == id } ),
			let view = table?.view(atColumn: 0, row: firstIndex, makeIfNecessary: false) as? TodoCell
		else {
			return
		}
		view.focusOn()
	}

	func scrollTo(_ id: UUID) {
		guard
			let firstIndex = items.firstIndex(where: { $0.uuid == id } )
		else {
			return
		}
		NSAnimationContext.runAnimationGroup { context in
			context.allowsImplicitAnimation = true
			table?.scrollRowToVisible(firstIndex)
		}
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

		let item = items[row]

		switch item {
		case .header(let title):
			let id = NSUserInterfaceItemIdentifier("header")
			var view = table?.makeView(withIdentifier: id, owner: self) as? NSTextField
			if view == nil {
				view = NSTextField()
				view?.isEditable = false
				view?.isBordered = false
				view?.drawsBackground = false
				view?.font = NSFont.preferredFont(forTextStyle: .headline)
				view?.identifier = id
			}
			view?.stringValue = title
			return view
		case .custom(let uuid, let configuration):
			let id = NSUserInterfaceItemIdentifier(TodoCell.userIdentifier)
			var view = table?.makeView(withIdentifier: id, owner: self) as? TodoCell
			if view == nil {
				view = TodoCell()
				view?.identifier = id
			}

			view?.configure(configuration)

			view?.textAction = { [weak self] newValue in
				self?.output?.performModification(.setText(newValue), forTodos: [uuid])
			}
			view?.checkboxAction = { [weak self] newValue in
				self?.output?.performModification( .setStatus(newValue ? .done : .default), forTodos: [uuid])
			}
			return view
		}
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
//				let item = items[row]
//				self.output?.delete([item.uuid])
			})
		]
	}

	func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
		let item = items[row]

		switch item {
		case .custom:
			return false
		case .header:
			return true
		}
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
