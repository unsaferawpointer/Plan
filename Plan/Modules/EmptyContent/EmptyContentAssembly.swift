//
//  EmptyContentAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.02.2024.
//

import Cocoa

final class EmptyContentAssembly {

	static func assemble(_ state: EmptyContentViewState) -> NSViewController {
		let presenter = EmptyContentPresenter(state: state)
		return EmptyContentViewController { controller in
			controller.output = presenter
			presenter.view = controller
		}
	}
}
