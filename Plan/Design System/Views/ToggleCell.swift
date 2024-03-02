//
//  ToggleCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.03.2024.
//

import Cocoa

final class ToggleCell: NSView {

	private var configuration: Bool? {
		didSet {
			updateUserInterface()
		}
	}

	var checkboxAction: ((Bool) -> Void)?

	// MARK: - UI-Properties

	lazy var checkbox: NSButton = {
		let selector = #selector(checkboxDidChangeState(_:))
		let view = NSButton(
			checkboxWithTitle: "",
			target: self,
			action: selector
		)
		view.allowsMixedState = false
		view.image = NSImage(systemSymbolName: "star", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .small))
		view.alternateImage = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .small))
		view.contentTintColor = .tertiaryLabelColor
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

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

extension ToggleCell {

	func configure(_ configuration: Bool) {
		self.configuration = configuration
	}

}

// MARK: - Helpers
private extension ToggleCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		checkbox.state = configuration ? .on : .off
		checkbox.contentTintColor = configuration ? .systemYellow : .tertiaryLabelColor
	}

	func configureConstraints() {

		[checkbox].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			checkbox.centerYAnchor.constraint(equalTo: centerYAnchor),
			checkbox.centerXAnchor.constraint(equalTo: centerXAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension ToggleCell {

	@objc
	func checkboxDidChangeState(_ sender: NSButton) {
		let newValue = sender.state == .on
		checkboxAction?(newValue)
	}
}
