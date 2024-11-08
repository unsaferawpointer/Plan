//
//  ParserConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.08.2024.
//

import Foundation

struct ParserConfiguration {

	let indentWidth: Int
}

// MARK: - Templates
extension ParserConfiguration {

	static var `default`: Self {
		return .init(indentWidth: 4)
	}
}
