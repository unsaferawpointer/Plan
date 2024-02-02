//
//  TodosPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

protocol TodosPresenterProtocol: AnyObject {
	func present(_ todos: [Todo])
}

final class TodosPresenter {

	var interactor: TodosInteractorProtocol?

	weak var view: TodosView?

	var stateProvider: TodosStateProviderProtocol

	// MARK: - Initialization

	init(stateProvider: TodosStateProviderProtocol) {
		self.stateProvider = stateProvider
	}

}

// MARK: - TodosPresenterProtocol
extension TodosPresenter: TodosPresenterProtocol {

	func present(_ todos: [Todo]) {
		let models = todos.map { todo in
			makeModel(from: todo)
		}
		view?.display(models)
	}
}

// MARK: - TodosView
extension TodosPresenter: TodosViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}
		do {
			try interactor?.fetchTodos()
		} catch {
			// TODO: - Handle action
		}
	}

	func toolbarNewTodoButtonHasBeenClicked() {
		do {
			try interactor?.createTodo(withText: "New todo")
		} catch {
			// TODO: - Handle action
		}
	}

	func textfieldDidChange(_ newValue: String, for id: UUID) {
		do {
			try interactor?.setText(newValue, forTodo: id)
		} catch {
			// TODO: - Handle action
		}
	}

	func checkboxDidChange(_ newValue: Bool, for ids: [UUID]) {
		do {
			try interactor?.setStatus(newValue, forTodos: ids)
		} catch {
			// TODO: - Handle action
		}
	}

	func delete(_ id: UUID) {
		do {
			try interactor?.deleteTodo(withId: id)
		} catch {
			// TODO: - Handle action
		}
	}

	func selectionDidChange(_ newValue: [UUID]) {
		stateProvider.selectTodos(newValue)
	}
}

// MARK: - Helpers
private extension TodosPresenter {

	func makeModel(from todo: Todo) -> TodoModel {
		return TodoModel(
			uuid: todo.uuid,
			isDone: todo.isDone,
			isFavorite: false,
			text: todo.text
		)
	}
}
