//
//  HeaderConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

/// Configuration of the label
struct HeaderConfiguration: FieldConfiguration {

	typealias Field = HeaderField

	/// Field title
	var title: String

	/// View-model of the button
	var button: Button?
}

// MARK: - Nested data structs
extension HeaderConfiguration {

	/// View-model of the button
	struct Button {
		var title: String
		var action: () -> Void
	}
}

// MARK: - Equatable
extension HeaderConfiguration.Button: Equatable {

	typealias Button = HeaderConfiguration.Button

	static func == (lhs: Button, rhs: Button) -> Bool {
		return lhs.title == rhs.title
	}
}
