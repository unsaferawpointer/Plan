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

	var grouping: TodosGrouping

	// MARK: - Initialization

	init(
		stateProvider: TodosStateProviderProtocol,
		infoDelegate: InfoDelegate,
		grouping: TodosGrouping = .none
	) {
		self.stateProvider = stateProvider
		self.infoDelegate = infoDelegate
		self.grouping = grouping
	}

}

// MARK: - TodosPresenterProtocol
extension TodosPresenter: TodosPresenterProtocol {

	func present(_ todos: [Todo]) {

		guard !todos.isEmpty else {
			let state: TodosViewState = .placeholder(
				title: "No todos, yet",
				subtitle: "Add new todo using the plus button",
				image: "ghost"
			)
			view?.display(state)
			infoDelegate?.infoDidChange("No incomplete todos")
			return
		}

		var total: [TableItem] = []

		switch grouping {
		case .none:
			let items = todos.map { todo in
				makeModel(from: todo)
			}.map { model in
				TableItem.custom(model)
			}
			total.append(contentsOf: items)
		case .list:
			let grouped = Dictionary(grouping: todos) { todo in
				return todo.listName ?? ""
			}

			let sorted = grouped.sorted { lhs, rhs in
				return lhs.key < rhs.key
			}

			for section in sorted {
				total.append(.header(section.key))
				let items = section.value.map { todo in
					makeModel(from: todo)
				}.map { model in
					TableItem.custom(model)
				}
				total.append(contentsOf: items)
			}
		}

		view?.display(.content(items: total))
		infoDelegate?.infoDidChange("\(todos.count) incomplete todos")
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
		case .markAsCompleted:
			performModification(.setStatus(.done), forTodos: view.selection)
		case .markAsIncomplete:
			performModification(.setStatus(.default), forTodos: view.selection)
		case .uuid(let value):
			performModification(.setList(value), forTodos: view.selection)
		case .focusOn:
			performModification(.setStatus(.inFocus), forTodos: view.selection)
		case .moveToBacklog:
			performModification(.setStatus(.default), forTodos: view.selection)
		case .basic("urgency_none"):
			performModification(.setUrgency(.none), forTodos: view.selection)
		case .basic("urgency_middle"):
			performModification(.setUrgency(.middle), forTodos: view.selection)
		case .basic("urgency_high"):
			performModification(.setUrgency(.high), forTodos: view.selection)
		default:
			break
		}
	}

	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool {
		switch item {
		case .newTodo:
			return true
		case .delete, .moveToList, .markAsCompleted, .markAsIncomplete, .uuid, .focusOn, .setUrgency, .basic:
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
			isDone: todo.status.isDone,
			urgency: todo.urgency,
			text: todo.text,
			listName: todo.listName,
			creationDate: todo.creationDate
		)
	}
}
