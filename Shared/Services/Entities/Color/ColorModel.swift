//
//  ColorModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

enum ColorModel: Int {

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
	case mint
	case teal
	case cyan
	case blue
	case indigo
	case purple
	case pink

}

// MARK: - Codable
extension ColorModel: Codable { }

// MARK: - CaseIterable
extension ColorModel: CaseIterable { }

#if canImport(Cocoa)

import Cocoa

extension ColorModel {

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
		case .mint:
			return .systemMint
		case .teal:
			return .systemTeal
		case .cyan:
			return .systemCyan
		case .blue:
			return .systemBlue
		case .indigo:
			return .systemIndigo
		case .purple:
			return .systemPurple
		case .pink:
			return .systemPink
		}
	}
}
#endif

// MARK: - Computed properties
extension ColorModel {

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
		case .mint:
			return String(localized: "mint", table: "Color")
		case .teal:
			return String(localized: "teal", table: "Color")
		case .cyan:
			return String(localized: "cyan", table: "Color")
		case .blue:
			return String(localized: "blue", table: "Color")
		case .indigo:
			return String(localized: "indigo", table: "Color")
		case .purple:
			return String(localized: "purple", table: "Color")
		case .pink:
			return String(localized: "pink", table: "Color")
		}
	}
}
