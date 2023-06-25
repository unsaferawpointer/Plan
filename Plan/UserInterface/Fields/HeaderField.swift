//
//  HeaderField.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

class HeaderField: NSTableCellView, ConfigurableField {

	typealias Configuration = HeaderConfiguration

	static var userIdentifier: String = "header"

	var configuration: Configuration {
		didSet {
			updateInterface()
		}
	}

	func configure(_ configuration: HeaderConfiguration) {
		self.configuration = configuration
	}

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - configuration: Field configuration
	required init(_ configuration: Configuration) {
		self.configuration = configuration
		super.init(frame: .zero)
		configureUserInterface()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - HeaderField
private extension HeaderField {

	func updateInterface() {
		guard textField?.stringValue != configuration.title else {
			return
		}
		textField?.stringValue = configuration.title
	}

	func configureUserInterface() {

		let textfield = NSTextField()
		textfield.isBordered = false
		textfield.font = NSFont.preferredFont(forTextStyle: .headline, options: [:])
		textfield.drawsBackground = false
		textfield.isEditable = false
		textfield.usesSingleLineMode = true
		textfield.lineBreakMode = .byTruncatingMiddle

		self.textField = textfield
		addSubview(textfield)
	}
}
