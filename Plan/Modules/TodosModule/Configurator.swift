//
//  Configurator.swift
//  Plan
//
//  Created by Anton Cherkasov on 09.03.2024.
//

final class Configurator { }

extension Configurator {

	func predicate(for behaviour: Behaviour) -> TodosPredicate {
		switch behaviour {
		case .inFocus:		return .status(.inFocus)
		case .backlog:		return .status(.default)
		case .archieve:		return .status(.done)
		case .list(let id): return .list(id)
		}
	}

	func sortOrder(for behaviour: Behaviour) -> [TodosOrder] {
		switch behaviour {
		case .inFocus:	return [.urgency, .isDone, .creationDate]
		case .backlog:	return [.urgency, .creationDate]
		case .archieve:	return [.creationDate]
		case .list:		return [.isDone, .urgency, .creationDate]
		}
	}

	func defaultGrouping(for behaviour: Behaviour) -> TodosGrouping {
		switch behaviour {
		case .inFocus:	return .urgency
		case .backlog:	return .list
		case .archieve:	return .none
		case .list:		return .none
		}
	}

	func elements(for behaviour: Behaviour) -> CellElements {
		switch behaviour {
		case .inFocus:	return [.icon, .textfield, .trailingLabel]
		case .backlog:	return [.icon, .textfield, .trailingLabel]
		case .archieve:	return [.icon, .textfield, .trailingLabel]
		case .list:		return [.icon, .textfield]
		}
	}
}
