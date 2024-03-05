//
//  ImageCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.03.2024.
//

import Cocoa

final class ImageCell: NSView {

	private var configuration: ImageCellConfiguration? {
		didSet {
			updateUserInterface()
		}
	}

	// MARK: - UI-Properties

	lazy var imageView: NSImageView = {
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

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

extension ImageCell {

	func configure(_ configuration: ImageCellConfiguration?) {
		self.configuration = configuration
	}

}

// MARK: - Helpers
private extension ImageCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		imageView.image = NSImage(systemSymbolName: configuration.icon, accessibilityDescription: nil)
		imageView.contentTintColor = configuration.tint.color
	}

	func configureConstraints() {

		[imageView].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

struct ImageCellConfiguration {
	var icon: String
	var tint: TintColor
}
