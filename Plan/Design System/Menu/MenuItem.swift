//
//  MenuItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

struct MenuItem {

	private var state: [String: State]

	private var validation: [String: Bool]

	init(state: [String : State], validation: [String : Bool]) {
		self.state = state
		self.validation = validation
	}
}

// MARK: - Public interface
extension MenuItem {

	func stateFor(_ id: String) -> State {
		return state[id] ?? .off
	}

	func isValid(_ id: String) -> Bool {
		return validation[id] ?? false
	}
}

// MARK: - Nested data structs
extension MenuItem {

	enum State {
		case off
		case on
	}
}
