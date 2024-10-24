//
//  ListTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.10.2024.
//

import Cocoa

final class ListTableAdapter: NSObject {

	weak var table: NSTableView?

	var columns: [any TableColumn<ListItemViewModel>]?

	// MARK: - UI-State

	private(set) var selection = Set<UUID>()

	var effectiveSelection: [UUID] {
		guard let table else {
			return []
		}
		return table.effectiveSelection().map {
			snapshot.items[$0].id
		}
	}

	// MARK: - Data

	var snapshot: ListSnapshot<ListItemViewModel> = .init(items: [])

	// MARK: - Initialization

	init(table: NSTableView) {
		self.table = table
		super.init()

		table.delegate = self
		table.dataSource = self
	}
}

// MARK: - Public interface
extension ListTableAdapter {

	func configure(columns: [any TableColumn<ListItemViewModel>]) {
		self.columns = columns
	}

	func apply(_ new: ListSnapshot<ListItemViewModel>) {
		self.snapshot = new
		table?.reloadData()
	}

	func scroll(to id: UUID) {
		guard let table, let row = snapshot.cache[id] else {
			return
		}
		NSAnimationContext.runAnimationGroup { context in
			context.allowsImplicitAnimation = true
			table.scrollRowToVisible(row)
		}
	}

	func select(_ id: UUID) {
		guard let table, let row = snapshot.cache[id] else {
			return
		}
		table.selectRowIndexes(.init(integer: row), byExtendingSelection: false)
	}

	func focus(on id: UUID) {
		guard let row = snapshot.cache[id] else {
			return
		}
		let view = table?.view(atColumn: 0, row: row, makeIfNecessary: false) as? ItemCell
		_ = view?.becomeFirstResponder()
	}
}

// MARK: - NSTableViewDataSource
extension ListTableAdapter: NSTableViewDataSource {

	func numberOfRows(in tableView: NSTableView) -> Int {
		snapshot.items.count
	}
}

// MARK: - NSTableViewDelegate
extension ListTableAdapter: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		guard let tableColumn else {
			return nil
		}

		let model = snapshot.items[row]

		let identifier = tableColumn.identifier.rawValue
		guard let index = columns?.firstIndex(where: { $0.identifier == identifier }), let columns else {
			return nil
		}
		return columns[index].makeCellIfNeeded(from: model, in: tableView)
	}

	func tableView(_ tableView: NSTableView, userCanChangeVisibilityOf column: NSTableColumn) -> Bool {
		let optionalColumns = columns?.filter {
			!$0.options.isRequired
		}.map(\.identifier)

		return optionalColumns?.contains(column.identifier.rawValue) ?? false
	}
}

// MARK: - Menu support
extension ListTableAdapter {

	func validateMenuItem(_ itemIdentifier: String) -> Bool {

		for index in table?.effectiveSelection() ?? [] {
			let model = snapshot.items[index]
			if model.menu.isValid(itemIdentifier) {
				return true
			}
		}

		return false
	}

	func menuItemState(for itemIdentifier: String) -> NSControl.StateValue {

		var hasEnabled = false
		var hasDisabled = false

		for index in table?.effectiveSelection() ?? [] {
			let model = snapshot.items[index]
			let state = model.menu.stateFor(itemIdentifier)
			switch state {
			case .off:	hasDisabled = true
			case .on:	hasEnabled = true
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

// MARK: - Helpers
private extension ListTableAdapter {

	func configureRow(with model: ListItemViewModel, at row: Int) {
		guard let table else {
			return
		}
		for column in columns ?? [] {
			column.configureCell(for: model, at: row, in: table)
		}
	}
}
