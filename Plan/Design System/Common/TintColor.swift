//
//  TintColor.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.03.2024.
//

import AppKit

enum TintColor {
	case `default`
	case monochrome
	case yellow
	case blue
	case mint
	case teal
	case indigo
	case red
}

extension TintColor {

	var configuration: NSTintConfiguration {
		switch self {
		case .default:
			return .default
		case .monochrome:
			return .monochrome
		case .yellow:
			return .init(preferredColor: .systemYellow)
		case .blue:
			return .init(preferredColor: .systemBlue)
		case .mint:
			return .init(preferredColor: .systemMint)
		case .teal:
			return .init(preferredColor: .systemTeal)
		case .indigo:
			return .init(preferredColor: .systemIndigo)
		case .red:
			return .init(preferredColor: .systemRed)
		}
	}

	var color: NSColor {
		switch self {
		case .default:
			return .controlAccentColor
		case .monochrome:
			return .secondaryLabelColor
		case .yellow:
			return .systemYellow
		case .blue:
			return .systemBlue
		case .mint:
			return .systemMint
		case .teal:
			return .systemTeal
		case .indigo:
			return .systemIndigo
		case .red:
			return .systemRed
		}
	}
}
