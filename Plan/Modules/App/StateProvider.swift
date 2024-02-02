//
//  StateProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation

protocol StateProviderDelegate: AnyObject {
	func providerDidChangeState(_ state: State)
}

final class StateProvider {

	var state: State = .init() {
		didSet {
			delegate?.providerDidChangeState(state)
		}
	}

	weak var delegate: StateProviderDelegate?

}

// MARK: - SidebarStateProviderProtocol
extension StateProvider: SidebarStateProviderProtocol {

	func navigate(to route: Route) {
		state.selection.route = route
	}
}

// MARK: - ProjectsStateProviderProtocol
extension StateProvider: ProjectsStateProviderProtocol {

	func selectProjects(_ ids: [UUID]) {
		state.selection.projects = ids
	}
}

// MARK: - TodosStateProviderProtocol
extension StateProvider: TodosStateProviderProtocol {

	func selectTodos(_ ids: [UUID]) {
		state.selection.todos = ids
	}
}

struct State {

	var selection: Selection = .init(route: .backlog)
}

struct Selection {

	var route: Route
	var projects: [UUID] = []
	var todos: [UUID] = []
}
