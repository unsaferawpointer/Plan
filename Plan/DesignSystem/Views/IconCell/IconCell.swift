//
//  IconCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.10.2024.
//

import Cocoa

final class IconCell: NSView, TableCell {

	static var reuseIdentifier: String = "icon_cell"

	var model: IconModel {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((Model.Value) -> Void)?

	// MARK: - UI-Properties

	lazy var imageView: NSImageView = {
		let view = NSImageView()
		return view
	}()

	// MARK: - Initialization

	init(_ model: IconModel) {
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
private extension IconCell {

	func updateUserInterface() {
		guard let iconName = model.value.icon else {
			imageView.isHidden = true
			return
		}

		let color = model.configuration.color?.colorValue ?? .tertiaryLabelColor
		imageView.isHidden = false
		imageView.image = NSImage(systemSymbolName: iconName.rawValue)?
			.withSymbolConfiguration(.init(hierarchicalColor: color))
	}

	func configureConstraints() {

		[imageView].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }

	}
}
