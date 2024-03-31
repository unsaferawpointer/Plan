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

	var settingsProvider: TodosSettingsProviderProtocol

	weak var infoDelegate: InfoDelegate?

	var behaviour: Behaviour

	var itemsFactory: TodoItemsFactoryProtocol

	// MARK: - Initialization

	init(
		infoDelegate: InfoDelegate,
		behaviour: Behaviour,
		itemsFactory: TodoItemsFactoryProtocol,
		settingsProvider: TodosSettingsProviderProtocol
	) {
		self.settingsProvider = settingsProvider
		self.infoDelegate = infoDelegate
		self.behaviour = behaviour
		self.itemsFactory = itemsFactory
		self.settingsProvider = settingsProvider
		self.settingsProvider.delegate = self
	}

}

// MARK: - TodosPresenterProtocol
extension TodosPresenter: TodosPresenterProtocol {

	func present(_ todos: [Todo]) {

		guard !todos.isEmpty else {
			let state: TodosViewState = .placeholder(
				title: itemsFactory.placeholderTitle,
				subtitle: itemsFactory.placeholderSubtitle,
				image: "ghost"
			)
			view?.display(state)
			infoDelegate?.infoDidChange(itemsFactory.infoSubtitleForEmptyState)
			return
		}

		let grouping = settingsProvider.getGrouping(for: behaviour)

		let items = itemsFactory.makeItems(
			from: todos,
			grouping: grouping,
			behaviour: behaviour
		)

		view?.display(.content(items: items))

		let subtitle = {
			switch behaviour {
			case .archieve:
				return itemsFactory.infoSubtitleCompletedTodos(count: todos.count)
			case .backlog, .inFocus:
				return itemsFactory.infoSubtitle(for: todos.count)
			default:
				let count = todos.filter { $0.isDone == false }.count
				return count == 0
					? itemsFactory.infoSubtitleAllTasksAreCompleted
					: itemsFactory.infoSubtitle(for: count)
			}
		}()

		infoDelegate?.infoDidChange(subtitle)
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
		// TODO: - Handle action
	}
}

// MARK: - TodosSettingsDelegate
extension TodosPresenter: TodosSettingsDelegate {

	func settingsDidChange() {
		try? self.interactor?.fetchTodos()
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
		case .list(let value):
			performModification(.setList(value), forTodos: view.selection)
		case .focusOn:
			performModification(.setStatus(.inFocus), forTodos: view.selection)
		case .moveToBacklog:
			performModification(.setStatus(.default), forTodos: view.selection)
		case .priority(let value):
			performModification(.setPriority(value), forTodos: view.selection)
		case .grouping(let value):
			settingsProvider.setGrouping(value, for: behaviour)
		default:
			break
		}
	}

	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool {
		switch item {
		case .grouping(let value):
			switch value {
			case .none, .priority:
				return true
			case .list:
				guard case .list = behaviour else {
					return true
				}
				return false
			case .status:
				guard case .list = behaviour else {
					return false
				}
				return true
			}
		case .newTodo, .file, .editor:
			return true
		case .delete,
				.moveToList,
				.markAsCompleted,
				.markAsIncomplete,
				.list,
				.focusOn,
				.priority,
				.moveToBacklog,
				.setPriority:
			return view?.selection.isEmpty == false
		default:
			return false
		}
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
