//
//  StateProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation

protocol StateProviderDelegate: AnyObject {
	func selectionDidChange(new: Selection, old: Selection)
}

final class StateProvider {

	var selection: Selection = .init(route: .focus) {
		didSet {
			delegate?.selectionDidChange(new: selection, old: oldValue)
		}
	}

	weak var delegate: StateProviderDelegate?

}

// MARK: - SidebarStateProviderProtocol
extension StateProvider: SidebarStateProviderProtocol {

	func navigate(to route: Route) {
		selection.route = route
	}
}

// MARK: - ProjectsStateProviderProtocol
extension StateProvider: ProjectsStateProviderProtocol {

	func selectProjects(_ ids: [UUID]) {
		selection.projects = ids
	}
}

// MARK: - TodosStateProviderProtocol
extension StateProvider: TodosStateProviderProtocol {

	func selectTodos(_ ids: [UUID]) {
		selection.todos = ids
	}
}

struct Selection {

	var route: Route
	var projects: [UUID] = []
	var todos: [UUID] = []
}
