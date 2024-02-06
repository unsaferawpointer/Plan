//
//  TodosAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class TodosAssembly {

	static func assemble(
		stateProvider: TodosStateProviderProtocol,
		configuration: TodosConfiguration,
		infoDelegate: InfoDelegate
	) -> NSViewController {
		let presenter = TodosPresenter(stateProvider: stateProvider, infoDelegate: infoDelegate)
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let factory = TodosFactory(configuration: configuration)
		let interactor = TodosInteractor(
			presenter: presenter,
			provider: TodosDataProvider(context: context!, configuration: configuration),
			storage: storage, 
			factory: factory
		)

		let menu = TodosMenuAssembly.assemble(output: presenter)

		return TodosViewController(menu) { viewController in
			viewController.output = presenter
			presenter.interactor = interactor
			presenter.view = viewController
		}
	}
}
