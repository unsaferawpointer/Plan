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
		predicate: TodosPredicate,
		infoDelegate: InfoDelegate
	) -> NSViewController {
		let presenter = TodosPresenter(stateProvider: stateProvider, infoDelegate: infoDelegate)
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let factory = TodosFactory(configuration: predicate)
		let interactor = TodosInteractor(
			presenter: presenter,
			provider: TodosDataProvider(
				context: context!,
				predicate: predicate,
				order: [.isFavorite, .isDone, .creationDate]
			),
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
