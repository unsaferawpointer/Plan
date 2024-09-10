//
//  TextCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.08.2024.
//

import Cocoa

final class TextCell: NSView, TableCell {

	static var reuseIdentifier: String = "text_cell"

	var model: Model {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((String) -> Void)?

	// MARK: - UI-Properties

	lazy var textfield: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.cell?.sendsActionOnEndEditing = true
		view.target = self
		view.action = #selector(textfieldDidChange(_:))
		return view
	}()

	// MARK: - Initialization

	init(_ model: Model) {
		self.model = model
		super.init(frame: .zero)
		configureConstraints()
	}

	@available(*, unavailable, message: "Use init(textDidChange: checkboxDidChange:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView life-cycle

	override func prepareForReuse() {
		super.prepareForReuse()
	}

	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
		return textfield.becomeFirstResponder()
	}
}

// MARK: - Helpers
private extension TextCell {

	func updateUserInterface() {
		textfield.text = model.value
		textfield.textColor = model.configuration.textColor.colorValue
		textfield.formatter = model.configuration.validation?.value
		textfield.isEditable = model.configuration.isEditable
	}

	func configureConstraints() {

		[textfield].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			textfield.centerYAnchor.constraint(equalTo: centerYAnchor),
			textfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			textfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }

	}
}

// MARK: - Actions
extension TextCell {

	@objc
	func textfieldDidChange(_ sender: NSTextField) {
		guard sender === textfield else {
			return
		}

		let text = sender.stringValue

		action?(text)
	}

}

extension TextCell {

	struct Model: CellModel {

		typealias Value = String

		typealias Configuration = TextCell.Configuration

		let configuration: TextCell.Configuration

		let value: String

	}

	struct Configuration {
		let textColor: Color
		let isEditable: Bool
		let validation: Validation?
	}

	enum Validation {
		case integer
	}
}

extension TextCell.Validation {

	var value: NumberFormatter {
		switch self {
		case .integer:
			return ValueFormatter()
		}
	}
}
