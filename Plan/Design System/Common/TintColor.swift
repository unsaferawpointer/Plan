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
		}
	}
}
