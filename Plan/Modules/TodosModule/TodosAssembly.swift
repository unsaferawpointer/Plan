//
//  TodosAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class TodosAssembly {

	static func assemble(stateProvider: TodosStateProviderProtocol, configuration: TodosConfiguration) -> NSViewController {
		let presenter = TodosPresenter(stateProvider: stateProvider)
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let interactor = TodosInteractor(
			presenter: presenter,
			provider: TodosDataProvider(context: context!, configuration: configuration),
			storage: storage
		)

		return TodosViewController { viewController in
			viewController.output = presenter
			presenter.interactor = interactor
			presenter.view = viewController
		}
	}
}
