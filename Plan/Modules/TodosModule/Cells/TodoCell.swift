//
//  TodoCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Cocoa

final class TodoCell: NSView {

	private var configuration: Configuration? {
		didSet {
			updateUserInterface()
		}
	}

	var textAction: ((String) -> Void)?

	var checkboxAction: ((Bool) -> Void)?

	// MARK: - UI-Properties

	lazy var basicStack: NSStackView = {
		let view = NSStackView(
			views: [checkbox, iconView, titleTextfield, trailingLabel]
		)
		view.alignment = .firstBaseline
		view.orientation = .horizontal
		return view
	}()

	lazy var checkbox: NSButton = {
		let selector = #selector(checkboxDidChangeState(_:))
		let view = NSButton(
			checkboxWithTitle: "",
			target: self,
			action: selector
		)
		view.allowsMixedState = false
		view.image = NSImage(symbolName: "checkbox", variableValue: 0.0)?
			.withSymbolConfiguration(.init(scale: .small))?
			.withSymbolConfiguration(.init(textStyle: .body))
		view.alternateImage = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .small))?
			.withSymbolConfiguration(.init(textStyle: .body))
		view.contentTintColor = .tertiaryLabelColor
		return view
	}()

	lazy var titleTextfield: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.isEditable = true
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.cell?.sendsActionOnEndEditing = true
		view.target = self
		view.action = #selector(textfieldDidChangeText(_:))
		return view
	}()

	lazy var trailingLabel: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .none
		view.isBordered = false
		view.isEditable = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.textColor = .tertiaryLabelColor
		return view
	}()

	lazy var iconView: NSImageView = {
		let view = NSImageView()
		return view
	}()

	// MARK: - ConfigurableField

	init() {
		super.init(frame: .zero)
		configureConstraints()
		updateUserInterface()
	}

	@available(*, unavailable, message: "Use init(_:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView life-cycle

	override func layout() {
		super.layout()
		wantsLayer = true
		layer?.backgroundColor = NSColor.quinaryLabel.cgColor
		layer?.cornerRadius = 4
	}

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: - ConfigurableView
extension TodoCell: ConfigurableView {

	static var userIdentifier: String = "todocell"

	typealias Configuration = TodoCellConfiguration

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
	}

}

// MARK: - Public interface
extension TodoCell {

	func focusOn() {
		titleTextfield.becomeFirstResponder()
	}
}

// MARK: - Helpers
private extension TodoCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		titleTextfield.isHidden = !configuration.elements.contains(.textfield)
		titleTextfield.stringValue = configuration.text
		titleTextfield.textColor = configuration.textColor.color

		trailingLabel.isHidden = !configuration.elements.contains(.trailingLabel)
		trailingLabel.stringValue = configuration.trailingText

		checkbox.state = configuration.checkboxValue ? .on : .off

		iconView.isHidden = !configuration.elements.contains(.icon)
		iconView.contentTintColor = configuration.iconTint.color
		iconView.image =  NSImage(systemSymbolName: configuration.iconName, accessibilityDescription: nil)
	}

	func configureConstraints() {

		[basicStack].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		basicStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
		basicStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		trailingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		trailingLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

		[
			basicStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			basicStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			basicStack.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension TodoCell {

	@objc
	func textfieldDidChangeText(_ sender: NSTextField) {
		let newValue = sender.stringValue
		textAction?(newValue)
	}

	@objc
	func checkboxDidChangeState(_ sender: NSButton) {
		let newValue = sender.state == .on
		checkboxAction?(newValue)
	}
}
