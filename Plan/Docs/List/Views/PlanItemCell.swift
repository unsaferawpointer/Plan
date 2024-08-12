//
//  PlanItemCell.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

protocol ListItemViewOutput: AnyObject {
	func textfieldDidChange(_ id: UUID, newText: String)
	func checkboxDidChange(_ id: UUID, newValue: Bool)
}

final class PlanItemCell: NSView {

	weak var delegate: ListItemViewOutput?

	static var reuseIdentifier: String = "label"

	var model: HierarchyModel {
		didSet {
			updateUserInterface()
		}
	}

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

	lazy var badge: NSButton = {
		let view = NSButton()
		view.setButtonType(.momentaryChange)
		view.bezelStyle = .badge
		view.isHidden = true
		return view
	}()

	lazy var container: NSStackView = {
		let view = NSStackView(views: [checkbox, imageView, textfield, badge])
		view.orientation = .horizontal
		view.distribution = .fillProportionally
		view.alignment = .lastBaseline
		return view
	}()

	// MARK: - Initialization

	init(_ model: HierarchyModel) {
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

		let content = model.content

		textfield.text = content.text
		textfield.textColor = content.textColor.colorValue

		badge.isHidden = !model.hasBadge
		badge.title = "\(content.number)"

		checkbox.isHidden = !content.style.isCheckbox
		checkbox.state = content.isOn ? .on : .off

		switch content.style {
		case .checkbox:
			imageView.isHidden = true
		case .icon(let name, let color):
			imageView.isHidden = false
			imageView.image = NSImage(systemSymbolName: name)
			imageView.contentTintColor = color.colorValue
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
		delegate?.textfieldDidChange(model.id, newText: sender.stringValue)
	}

	@objc
	func checkboxDidChange(_ sender: NSButton) {
		guard sender === checkbox else {
			return
		}
		delegate?.checkboxDidChange(model.id, newValue: sender.state == .on)
	}
}