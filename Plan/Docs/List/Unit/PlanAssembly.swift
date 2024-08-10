//
//  PlanAssembly.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 03.10.2023.
//

import Cocoa

final class PlanAssembly {

	static func build(storage: DocumentStorage<HierarchyContent>) -> NSViewController {
		let presenter = PlanPresenter()
		let interactor = PlanInteractor(storage: storage)
		return PlanViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
			presenter.interactor = interactor
			interactor.presenter = presenter
		}
	}
}
