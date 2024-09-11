//
//  TextModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.09.2024.
//

import Foundation

struct TextModel: CellModel {

	typealias Value = String

	typealias Configuration = TextConfiguration

	let configuration: TextConfiguration

	let value: String

	// MARK: - Initialization

	init(configuration: Configuration, value: Value) {
		self.configuration = configuration
		self.value = value
	}
}
