//
//  TodoItemsFactoryMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 18.03.2024.
//

import Foundation
@testable import Plan

final class TodoItemsFactoryMock {
	
	var stubs: Stubs = .init()
}

// MARK: - TodoItemsFactoryProtocol
extension TodoItemsFactoryMock: TodoItemsFactoryProtocol {

	func makeItems(from todos: [Todo], grouping: TodosGrouping, behaviour: Behaviour) -> [TableItem] {
		stubs.items
	}
}

extension TodoItemsFactoryMock {

	struct Stubs {
		var items: [TableItem] = []
	}
}
