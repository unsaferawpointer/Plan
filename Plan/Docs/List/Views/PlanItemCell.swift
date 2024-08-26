//
//  PlanItemCell.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

final class PlanItemCell: NSView, TableCell {

	typealias Model = PlanItemModel

	static var reuseIdentifier: String = "item_cell"

	var model: Model {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((PlanItemModel) -> Void)?

	// MARK: - UI-Properties

	lazy var imageView: NSImageView = {
		return NSImageView()
	}()

	lazy var textfield: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.target = self
		view.action = #selector(textfieldDidChange(_:))
		return view
	}()

	lazy var checkbox: NSButton = {
		let view = NSButton(
			checkboxWithTitle: "",
			target: self,
			action: #selector(checkboxDidChange(_:))
		)
		view.title = ""
		view.allowsMixedState = false
		view.image = NSImage(symbolName: "checkbox", variableValue: 0.0)
		view.alternateImage = NSImage(systemSymbolName: "checkmark")?
			.withSymbolConfiguration(.init(textStyle: .headline))
		view.contentTintColor = .tertiaryLabelColor
		return view
	}()

	lazy var container: NSStackView = {
		let view = NSStackView(views: [checkbox, imageView, textfield])
		view.orientation = .horizontal
		view.distribution = .fillProportionally
		view.alignment = .lastBaseline
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
private extension PlanItemCell {

	func updateUserInterface() {

		textfield.text = model.text
		textfield.textColor = model.textColor.colorValue

		checkbox.isHidden = model.checkboxIsHidden
		if let isOn = model.isOn {
			checkbox.state = isOn ? .on : .off
		}

		imageView.isHidden = model.imageIsHidden
		imageView.contentTintColor = model.iconColor?.colorValue
		if let icon = model.icon {
			imageView.image = NSImage(systemSymbolName: icon)
		}
	}

	func configureConstraints() {

		[container].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			container.centerYAnchor.constraint(equalTo: centerYAnchor),
			container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }

	}
}

// MARK: - Actions
extension PlanItemCell {

	@objc
	func textfieldDidChange(_ sender: NSTextField) {
		guard sender === textfield else {
			return
		}
		var modificated = model
		modificated.text = sender.stringValue
		action?(modificated)
	}

	@objc
	func checkboxDidChange(_ sender: NSButton) {
		guard sender === checkbox else {
			return
		}
		var modificated = model
		modificated.isOn = sender.state == .on
		action?(modificated)
	}
}
