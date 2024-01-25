//
//  HierarchyTodoModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.01.2024.
//

import Foundation

struct HierarchyTodoModel {

	var id: UUID

	var isDone: Bool

	var text: String
}

// MARK: - Identifiable
extension HierarchyTodoModel: Identifiable { }

extension HierarchyTodoModel {

	static var random: HierarchyTodoModel {
		return .init(
			id: .init(),
			isDone: false,
			text: UUID().uuidString
		)
	}
}
