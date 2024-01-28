//
//  ProjectCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class ProjectCell: NSTableCellView, ConfigurableView {

	static var userIdentifier: String = "label"

	typealias Configuration = ProjectConfiguration

	private var configuration: Configuration = .init(uuid: .init(), title: "", subtitle: "") {
		didSet {
			updateUserInterface()
		}
	}

	var labelDidChangeText: ((String) -> Void)?

	// MARK: - UI-Properties

	lazy var titleLabel: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .headline)
		view.cell?.sendsActionOnEndEditing = true
		view.target = self
		view.action = #selector(labelDidChangeText(_:))
		return view
	}()

	lazy var subtitleLabel: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .caption1)
		view.textColor = .secondaryLabelColor
		view.usesSingleLineMode = true
		view.isEditable = false

		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		return view
	}()

	lazy var countLabel: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .caption1)
		view.textColor = .secondaryLabelColor
		view.usesSingleLineMode = true
		view.isEditable = false
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.required, for: .horizontal)

		return view
	}()

	lazy var iconView: NSImageView = {
		let view = NSImageView()
		return view
	}()

	lazy var countStack: NSStackView = {
		let view = NSStackView(views: [iconView, countLabel])
		view.spacing = 2
		view.orientation = .horizontal
		return view
	}()

	lazy var bottomStack: NSStackView = {
		let view = NSStackView(views: [subtitleLabel, NSView(), countStack])
		view.orientation = .horizontal
		view.distribution = .fill
		view.alignment = .firstBaseline
		return view
	}()

	lazy var stack: NSStackView = {
		let view = NSStackView(views: [titleLabel, bottomStack])
		view.orientation = .vertical
		view.alignment = .leading
		view.distribution = .fill
		view.spacing = 4
		return view
	}()

	// MARK: - ConfigurableField

	init() {
		super.init(frame: .zero)
		configureConstraints()
		configureUserInterface()
		updateUserInterface()
	}

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
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

// MARK: - Helpers
private extension ProjectCell {

	func updateUserInterface() {
		titleLabel.stringValue = configuration.title
		subtitleLabel.stringValue = configuration.subtitle

		iconView.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(textStyle: .caption1))
		iconView.contentTintColor = .systemYellow

		if let countText = configuration.countLabel {
			countLabel.stringValue = countText
			countStack.isHidden = false
		} else {
			countStack.isHidden = true
		}

	}

	func configureUserInterface() { }

	func configureConstraints() {

		[stack].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

			stack.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension ProjectCell {

	@objc
	func labelDidChangeText(_ sender: NSTextField) {
		let newValue = sender.stringValue
		labelDidChangeText?(newValue)
	}
}
