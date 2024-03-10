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

	var behaviour: Behaviour

	// MARK: - Initialization

	init(
		stateProvider: TodosStateProviderProtocol,
		infoDelegate: InfoDelegate,
		behaviour: Behaviour
	) {
		self.stateProvider = stateProvider
		self.infoDelegate = infoDelegate
		self.behaviour = behaviour
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

		let configurator = Configurator()

		var elements = configurator.elements(for: behaviour)

		switch configurator.defaultGrouping(for: behaviour) {
		case .none:
			let items = todos.map { todo in
				(todo.uuid, makeConfiguration(from: todo, elements: elements))
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
					(todo.uuid, makeConfiguration(from: todo, elements: elements))
				}.map { model in
					TableItem.custom(id: model.0, configuration: model.1)
				}
				total.append(contentsOf: items)
			}
		case .urgency:
			let grouped = Dictionary(grouping: todos) { todo in
				return todo.priority
			}

			let sorted = grouped.sorted { lhs, rhs in
				return lhs.key.rawValue > rhs.key.rawValue
			}

			for section in sorted {
				switch section.key {
				case .low:
					total.append(.header("Low Priority"))
				case .medium:
					total.append(.header("Medium Priority"))
				case .high:
					total.append(.header("High Priority"))
				}
				let items = section.value.map { todo in
					(todo.uuid, makeConfiguration(from: todo, elements: elements))
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
					(todo.uuid, makeConfiguration(from: todo, elements: elements))
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

	func delete(_ ids: [UUID]?) {
		guard let view else {
			return
		}
		do {
			let deleted = ids ?? view.selection
			try interactor?.perform(.delete(deleted))
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
		case .lowPriority:
			performModification(.setUrgency(.low), forTodos: view.selection)
		case .mediumPriority:
			performModification(.setUrgency(.medium), forTodos: view.selection)
		case .highPriority:
			performModification(.setUrgency(.high), forTodos: view.selection)
		default:
			break
		}
	}

	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool {
		switch item {
		case .newTodo:
			return true
		case .delete,
				.moveToList,
				.markAsCompleted,
				.markAsIncomplete,
				.uuid,
				.focusOn,
				.setUrgency,
				.moveToBacklog,
				.lowPriority,
				.mediumPriority,
				.highPriority:
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

		let iconTint = todo.isDone ? .secondaryText : todo.priority.color
		let textColor: TintColor = todo.isDone ? .secondaryText : .primaryText

		var modificatedElements = elements
		if todo.priority == .low {
			modificatedElements.remove(.icon)
		}

		return TodoCellConfiguration(
			checkboxValue: todo.status == .done,
			iconTint: iconTint,
			iconName: "bolt.fill",
			text: todo.text,
			textColor: textColor,
			trailingText: todo.listName ?? "",
			elements: modificatedElements
		)
	}
}

// MARK: - Computed properties
extension Priority {

	var color: TintColor {
		switch self {
		case .low:
			return .monochrome
		case .medium:
			return .yellow
		case .high:
			return .red
		}
	}
}
