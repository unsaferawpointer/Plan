//
//  ViewConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.01.2024.
//

import Cocoa

/// View-model configuration interface
protocol ViewConfiguration {

	associatedtype View: ConfigurableView where View.Configuration == Self

}

extension ViewConfiguration {

	/// Make field based on this configuration
	func makeField() -> NSView {
		let view = View()
		view.configure(self)
		return view
	}
}
