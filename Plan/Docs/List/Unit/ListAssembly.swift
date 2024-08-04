//
//  ListAssembly.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 03.10.2023.
//

import Cocoa

final class ListAssembly {

	static func build(storage: DocumentStorage<HierarchyContent>) -> NSViewController {
		let presenter = ListPresenter(storage: storage)
		return ListViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
		}
	}
}
