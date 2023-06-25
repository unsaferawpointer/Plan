//
//  ViewControllerOutput.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

protocol ViewControllerOutput {

	/// ViewController did change life-cycle state
	///
	/// - Parameters:
	///    - newState: New life-cycle state of the view-controller
	func viewControllerDidChangeState(_ newState: ViewControllerState)
}

enum ViewControllerState {
	case viewDidLoad
}
