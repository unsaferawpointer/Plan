//
//  ConfigurableField.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

/// Interface of the table field
protocol ConfigurableField: NSView {

	associatedtype Configuration

	/// Basic initialization
	///
	/// - Parameters:
	///    - configuration: Initial configuration
	init(_ configuration: Configuration)

	/// Update field
	///
	/// - Parameters:
	///    - configuration: New configuration
	func configure(_ configuration: Configuration)

	/// Reusable field identifier
	static var userIdentifier: String { get }
}
