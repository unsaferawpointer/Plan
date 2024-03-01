//
//  Todo+Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
@testable import Plan

extension Todo {

	static var random: Todo {
		return .init(
			uuid: .init(),
			creationDate: Date(),
			text: UUID().uuidString,
			isFavorite: Bool.random(),
			list: .init(),
			listName: UUID().uuidString
		)
	}
}
