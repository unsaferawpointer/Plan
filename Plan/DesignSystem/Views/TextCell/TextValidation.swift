//
//  TextValidation.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.09.2024.
//

import Foundation

enum TextValidation {
	case integer
}

// MARK: - Computed properties
extension TextValidation {

	var value: NumberFormatter {
		switch self {
		case .integer:
			return ValueFormatter()
		}
	}
}
