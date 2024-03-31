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

	var newTodoTitlePlaceholder: String {
		stubs.newTodoTitlePlaceholder
	}

	func infoSubtitle(for count: Int) -> String {
		stubs.infoSubtitleForCount
	}
	
	var infoSubtitleForEmptyState: String {
		stubs.infoSubtitleForEmptyState
	}
	
	var infoSubtitleAllTasksAreCompleted: String {
		stubs.infoSubtitleAllTasksAreCompleted
	}
	
	func infoSubtitleCompletedTodos(count: Int) -> String {
		stubs.infoSubtitleCompletedTodosForCount
	}
	
	var placeholderTitle: String {
		stubs.placeholderTitle
	}
	
	var placeholderSubtitle: String {
		stubs.placeholderSubtitle
	}

	func makeItems(from todos: [Todo], grouping: TodosGrouping, behaviour: Behaviour) -> [TableItem] {
		stubs.items
	}
}

extension TodoItemsFactoryMock {

	struct Stubs {

		var items: [TableItem] = []

		var infoSubtitleForCount: String = .random
		var infoSubtitleForEmptyState: String = .random
		var infoSubtitleAllTasksAreCompleted: String = .random
		var infoSubtitleCompletedTodosForCount: String = .random
		var placeholderTitle: String = .random
		var placeholderSubtitle: String = .random
		var newTodoTitlePlaceholder: String = .random
	}
}
