//
//  EmptyContentPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.02.2024.
//

final class EmptyContentPresenter {

	var state: EmptyContentViewState

	weak var view: EmptyContentView?

	init(state: EmptyContentViewState) {
		self.state = state
	}
}

// MARK: - EmptyContentViewOutput
extension EmptyContentPresenter: EmptyContentViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}
		view?.display(state)
	}
}
