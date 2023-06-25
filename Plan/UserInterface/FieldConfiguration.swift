//
//  FieldConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

/// View-model configuration interface
protocol FieldConfiguration: Equatable {

	associatedtype Field: ConfigurableField where Field.Configuration == Self

}

extension FieldConfiguration {

	/// Make field based on this configuration
	func makeField() -> NSView {
		return Field(self)
	}
}
