//
//  HierarchyAssembly.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 03.10.2023.
//

import Cocoa

final class HierarchyAssembly {

	static func build(storage: DocumentStorage<PlanContent>, provider: AnyStateProvider<PlanDocumentState>) -> NSViewController {
		let presenter = HierarchyPresenter(provider: provider)
		let interactor = HierarchyInteractor(storage: storage)
		return HierarchyViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
			presenter.interactor = interactor
			interactor.presenter = presenter
		}
	}
}
