//
//  ListUnitAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Cocoa

final class ListUnitAssembly {

	static func build(storage: DocumentStorage<PlanContent>) -> NSViewController {
		let presenter = ListUnitPresenter()
		let interactor = ListUnitInteractor(storage: storage)
		return ListUnitViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
			presenter.interactor = interactor
			interactor.presenter = presenter
		}
	}
}
