//
//  TextConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.09.2024.
//

import Foundation

struct TextConfiguration {

	let textColor: ColorModel
	let isEditable: Bool
	let validation: TextValidation?

	// MARK: - Initialization

	init(
		textColor: ColorModel = .primary,
		isEditable: Bool = false,
		validation: TextValidation? = nil
	) {
		self.textColor = textColor
		self.isEditable = isEditable
		self.validation = validation
	}
}
