//
//  Project+Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

extension Project {

	static var random: Project {
		return Project(
			uuid: .init(),
			title: UUID().uuidString,
			count: Int.random(in: 0...128)
		)
	}
}
