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

	var selection: Selection = .init(route: .inbox) {
		didSet {
			delegate?.selectionDidChange(new: selection, old: oldValue)
		}
	}

	weak var delegate: StateProviderDelegate?

}

// MARK: - SidebarStateProviderProtocol
extension StateProvider: SidebarStateProviderProtocol {

	func getRoute() -> Route {
		return selection.route
	}

	func navigate(to route: Route) {
		selection.route = route
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
	var todos: [UUID] = []
}
