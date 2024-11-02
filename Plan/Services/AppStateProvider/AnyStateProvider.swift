//
//  StateProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.10.2024.
//

import Foundation

final class AnyStateProvider<State> {

	private var observations = [(State) -> Bool]()

	private(set) var state: State

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - initialState: Initial state
	init(initialState: State) {
		self.state = initialState
	}
}

// MARK: - StateProvider
extension AnyStateProvider: StateProvider {

	func modificate(_ block: (inout State) -> Void) {
		block(&state)
		observations = observations.filter { $0(state) }
	}

	func addObservation<O: AnyObject>(
		for object: O,
		handler: @escaping (O, State) -> Void
	) {

		handler(object, state)

		// Each observation closure returns a Bool that indicates
		// whether the observation should still be kept alive,
		// based on whether the observing object is still retained.
		observations.append { [weak object] value in
			guard let object = object else {
				return false
			}

			handler(object, value)
			return true
		}
	}
}
