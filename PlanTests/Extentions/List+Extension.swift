//
//  List+Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
@testable import Plan

extension List {

	static var random: List {
		return List(
			uuid: .init(),
			title: UUID().uuidString,
			count: Int.random(in: 0...128)
		)
	}
}
