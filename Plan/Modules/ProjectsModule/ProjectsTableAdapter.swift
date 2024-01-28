//
//  ProjectsTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation
import AppKit

final class ProjectsTableAdapter: NSObject {

	weak var table: NSTableView?

	var items: [ProjectConfiguration] = []

	var labelDidChangeText: ((UUID, String) -> Void)?

	var selection: (([UUID]) -> Void)?

	init(table: NSTableView? = nil) {
		self.table = table

		super.init()

		table?.delegate = self
		table?.dataSource = self
	}
}

extension ProjectsTableAdapter {

	func apply(_ items: [ProjectConfiguration]) {
		self.items = items
		table?.reloadData()
	}
}

// MARK: - NSTableViewDataSource
extension ProjectsTableAdapter: NSTableViewDataSource {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return items.count
	}
}

// MARK: - NSTableViewDelegate
extension ProjectsTableAdapter: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let configuration = items[row]

		let id = NSUserInterfaceItemIdentifier(LabelView.userIdentifier)
		var view = table?.makeView(withIdentifier: id, owner: self) as? ProjectCell
		if view == nil {
			view = ProjectCell()
			view?.identifier = id
		}

		view?.configure(configuration)
		view?.labelDidChangeText = { [weak self] newValue in
			self?.labelDidChangeText?(configuration.uuid, newValue)
		}

		return view
	}
}

// MARK: - Selection support
extension ProjectsTableAdapter {

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
