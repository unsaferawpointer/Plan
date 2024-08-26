//
//  TextColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Foundation

struct TextColumn<Model: Identifiable>: TableColumn {

	typealias Value = String

	typealias Cell = TextCell

	let identifier: String

	let keyPath: KeyPath<Model, String>

	let title: String

	var action: ((Model.ID, String) -> Void)?

	// MARK: - Initialization

	init(
		identifier: String,
		keyPath: KeyPath<Model, String>,
		title: String,
		action: ((Model.ID, String) -> Void)? = nil
	) {
		self.identifier = identifier
		self.keyPath = keyPath
		self.title = title
		self.action = action
	}
}
