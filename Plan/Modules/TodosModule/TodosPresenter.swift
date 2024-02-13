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

	weak var infoDelegate: InfoDelegate?

	// MARK: - Initialization

	init(stateProvider: TodosStateProviderProtocol, infoDelegate: InfoDelegate) {
		self.stateProvider = stateProvider
		self.infoDelegate = infoDelegate
	}

}

// MARK: - TodosPresenterProtocol
extension TodosPresenter: TodosPresenterProtocol {

	func present(_ todos: [Todo]) {
		let models = todos.map { todo in
			makeModel(from: todo)
		}

		guard !models.isEmpty else {
			let state: TodosViewState = .placeholder(
				title: "No todos, yet",
				subtitle: "Add new todo using the plus button",
				image: "ghost"
			)
			view?.display(state)
			infoDelegate?.infoDidChange("No incomplete todos")
			return
		}

		view?.display(.content(models: models))
		infoDelegate?.infoDidChange("\(models.count) incomplete todos")
	}
}

// MARK: - TodosView
extension TodosPresenter: TodosViewOutput {

	func performModification(_ modification: TodoModification, forTodos ids: [UUID]) {
		do {
			try interactor?.perform(modification, forTodos: ids)
		} catch {
			// TODO: - Handle action
		}
	}

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

	func createTodo() {
		do {
			try interactor?.perform(.insert(["New todo"]))
		} catch {
			// TODO: - Handle action
		}
	}

	func delete(_ ids: [UUID]) {
		do {
			try interactor?.perform(.delete(ids))
		} catch {
			// TODO: - Handle action
		}
	}

	func selectionDidChange(_ newValue: [UUID]) {
		stateProvider.selectTodos(newValue)
	}
}

// MARK: - MenuDelegate
extension TodosPresenter: MenuDelegate {

	func menuItemHasBeenClicked(_ item: MenuItem.Identifier) {

		guard let view else {
			return
		}

		switch item {
		case .newTodo:
			createTodo()
		case .delete:
			delete(view.selection)
		case .bookmark:
			performModification(.bookmark, forTodos: view.selection)
		case .unbookmark:
			performModification(.unbookmark, forTodos: view.selection)
		case .markAsCompleted:
			performModification(.setStatus(true), forTodos: view.selection)
		case .markAsIncomplete:
			performModification(.setStatus(false), forTodos: view.selection)
		case .uuid(let value):
			performModification(.setList(value), forTodos: view.selection)
			break
		default:
			break
		}
	}

	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool {
		switch item {
		case .newTodo:
			return true
		case .delete, .moveToList, .bookmark, .unbookmark, .markAsCompleted, .markAsIncomplete, .uuid:
			guard let selection = view?.selection else {
				return false
			}
			return !selection.isEmpty
		default:
			return false
		}
	}
}

// MARK: - Helpers
private extension TodosPresenter {

	func makeModel(from todo: Todo) -> TodoModel {
		return TodoModel(
			uuid: todo.uuid,
			isDone: todo.isDone,
			isFavorite: todo.isFavorite, 
			inFocus: todo.inFocus,
			text: todo.text, 
			subtitle: todo.listName
		)
	}
}
