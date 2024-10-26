//
//  StateProvider.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Foundation

protocol StateProvider<State> {

	associatedtype State

	func modificate(_ block: (inout State) -> Void)

	func addObservation<O: AnyObject>(
		for object: O,
		handler: @escaping (O, State) -> Void
	)
}
