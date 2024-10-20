//
//  HierarchyAssembly.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 03.10.2023.
//

import Cocoa

final class HierarchyAssembly {

	static func build(storage: DocumentStorage<PlanContent>) -> NSViewController {
		let presenter = HierarchyPresenter()
		let interactor = HierarchyInteractor(storage: storage)
		return HierarchyViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
			presenter.interactor = interactor
			interactor.presenter = presenter
		}
	}
}
