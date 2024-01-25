//
//  ConfigurableView.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.01.2024.
//

import Cocoa

/// Interface of the table field
protocol ConfigurableView: NSView {

	associatedtype Configuration

	/// Update field
	///
	/// - Parameters:
	///    - configuration: New configuration
	func configure(_ configuration: Configuration)

	/// Reusable field identifier
	static var userIdentifier: String { get }
}
