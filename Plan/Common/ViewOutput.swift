//
//  ViewOutput.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol ViewOutput {
	func viewDidChange(state newState: ViewState)
}
