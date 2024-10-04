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
	case tertiary
	case yellow
	case red
	case quaternary
}

// MARK: - Computed properties
extension Color {

	var colorValue: NSColor {
		switch self {
		case .primary:
			return .labelColor
		case .secondary:
			return .secondaryLabelColor
		case .tertiary:
			return .tertiaryLabelColor
		case .yellow:
			return .systemYellow
		case .red:
			return .systemRed
		case .quaternary:
			return .quaternaryLabelColor
		}
	}
}
