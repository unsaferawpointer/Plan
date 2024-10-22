//
//  CheckboxCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Cocoa

final class CheckboxCell: NSView, TableCell {

	typealias Model = CheckboxCellModel

	static var reuseIdentifier: String = "item_cell"

	var model: Model {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((CheckboxCellModel.Value) -> Void)?

	// MARK: - UI-Properties

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
}

// MARK: - Helpers
private extension CheckboxCell {

	func updateUserInterface() {

		let value = model.value
		let configuration = model.configuration

		// Value
		checkbox.state = value.isOn ? .on : .off
	}

	func configureConstraints() {

		[checkbox].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			checkbox.centerYAnchor.constraint(equalTo: centerYAnchor),
			checkbox.centerXAnchor.constraint(equalTo: centerXAnchor)
		]
			.forEach { $0.isActive = true }

	}
}

// MARK: - Actions
extension CheckboxCell {

	@objc
	func checkboxDidChange(_ sender: NSButton) {
		guard sender === checkbox else {
			return
		}

		let isOn = sender.state == .on

		action?(.init(isOn: isOn))
	}
}
