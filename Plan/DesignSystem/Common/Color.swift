//
//  Color.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Cocoa

enum Color {
	case primary
	case secondary
	case yellow
}

// MARK: - Computed properties
extension Color {

	var colorValue: NSColor {
		switch self {
		case .primary:
			return .labelColor
		case .secondary:
			return .secondaryLabelColor
		case .yellow:
			return .systemYellow
		}
	}
}
