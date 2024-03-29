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
			priority: .medium,
			list: .init(),
			listName: UUID().uuidString
		)
	}

	static var completed: Todo {
		return .init(
			uuid: .init(),
			creationDate: Date(),
			text: UUID().uuidString,
			status: .done,
			priority: .medium,
			list: .init(),
			listName: UUID().uuidString
		)
	}

	static var incomplete: Todo {
		return .init(
			uuid: .init(),
			creationDate: Date(),
			text: UUID().uuidString,
			status: Bool.random() ? .inFocus : .default,
			priority: .medium,
			list: .init(),
			listName: UUID().uuidString
		)
	}
}
