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
				(todo.uuid, makeConfiguration(from: todo, elements: [.icon, .textfield, .trailingLabel]))
			}.map { model in
				TableItem.custom(id: model.0, configuration: model.1)
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
					(todo.uuid, makeConfiguration(from: todo, elements: [.icon, .textfield]))
				}.map { model in
					TableItem.custom(id: model.0, configuration: model.1)
				}
				total.append(contentsOf: items)
			}
		case .urgency:
			let grouped = Dictionary(grouping: todos) { todo in
				return todo.urgency
			}

			let sorted = grouped.sorted { lhs, rhs in
				return lhs.key.rawValue > rhs.key.rawValue
			}

			for section in sorted {
				switch section.key {
				case .none:
					total.append(.header("Not Urgency"))
				case .middle:
					total.append(.header("Middle Urgency"))
				case .high:
					total.append(.header("High Urgency"))
				}
				let items = section.value.map { todo in
					(todo.uuid, makeConfiguration(from: todo, elements: [.icon, .textfield, .trailingLabel]))
				}.map { model in
					TableItem.custom(id: model.0, configuration: model.1)
				}
				total.append(contentsOf: items)
			}
		case .status:
			let grouped = Dictionary(grouping: todos) { todo in
				return todo.status
			}

			let sorted = grouped.sorted { lhs, rhs in
				return lhs.key.rawValue < rhs.key.rawValue
			}

			for section in sorted {
				switch section.key {
				case .default:
					total.append(.header("Other"))
				case .inFocus:
					total.append(.header("In Focus"))
				case .done:
					total.append(.header("Done"))
				}
				let items = section.value.map { todo in
					(todo.uuid, makeConfiguration(from: todo, elements: [.icon, .textfield, .trailingLabel]))
				}.map { model in
					TableItem.custom(id: model.0, configuration: model.1)
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

	func setGrouping(_ grouping: TodosGrouping) {
		self.grouping = grouping
		do {
			try interactor?.fetchTodos()
		} catch {
			// TODO: - Handle action
		}
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

	func makeConfiguration(from todo: Todo, elements: CellElements) -> TodoCellConfiguration {

		let iconTint: TintColor = {
			switch todo.urgency {
			case .middle:
				return .yellow
			case .high:
				return .red
			default:
				return .monochrome
			}
		}()

		var modificatedElements = elements
		if todo.urgency == .none {
			modificatedElements.remove(.icon)
		}

		return TodoCellConfiguration(
			checkboxValue: todo.status == .done,
			iconTint: iconTint,
			iconName: "bolt.fill",
			text: todo.text,
			textColor: todo.status == .done ? .secondaryText : .primaryText,
			trailingText: todo.listName ?? "",
			elements: modificatedElements
		)
	}
}
