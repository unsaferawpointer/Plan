//
//  Color.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Cocoa

enum Color: Int {

	// MARK: - Basic
	case accent
	case primary
	case secondary
	case tertiary
	case quaternary

	// MARK: - Accent

	case red
	case orange
	case yellow
	case green
	case cyan
	case blue
	case purple

}

// MARK: - Codable
extension Color: Codable { }

// MARK: - CaseIterable
extension Color: CaseIterable { }

// MARK: - Computed properties
extension Color {

	var colorValue: NSColor {
		switch self {
		case .accent:
			return .controlAccentColor
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
		case .orange:
			return .systemOrange
		case .green:
			return .systemGreen
		case .cyan:
			return .systemCyan
		case .blue:
			return .systemBlue
		case .purple:
			return .systemPurple
		}
	}

	var displayName: String {
		switch self {
		case .accent:
			return String(localized: "accent", table: "Color")
		case .primary:
			return String(localized: "primary", table: "Color")
		case .secondary:
			return String(localized: "secondary", table: "Color")
		case .tertiary:
			return String(localized: "tertiary", table: "Color")
		case .yellow:
			return String(localized: "yellow", table: "Color")
		case .red:
			return String(localized: "red", table: "Color")
		case .quaternary:
			return String(localized: "quaternary", table: "Color")
		case .orange:
			return String(localized: "orange", table: "Color")
		case .green:
			return String(localized: "green", table: "Color")
		case .cyan:
			return String(localized: "cyan", table: "Color")
		case .blue:
			return String(localized: "blue", table: "Color")
		case .purple:
			return String(localized: "purple", table: "Color")
		}
	}
}
