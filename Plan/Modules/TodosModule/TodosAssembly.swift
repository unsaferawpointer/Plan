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
		infoDelegate: InfoDelegate,
		behaviour: Behaviour
	) -> NSViewController {
		let configurator = Configurator()
		let presenter = TodosPresenter(
			stateProvider: stateProvider,
			infoDelegate: infoDelegate,
			behaviour: behaviour, 
			settingsProvider: TodosSettingsProvider(behaviour: behaviour)
		)
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let factory = TodosFactory()
		let interactor = TodosInteractor(
			presenter: presenter,
			provider: TodosDataProvider(
				context: context!,
				predicate: configurator.predicate(for: behaviour),
				order: configurator.sortOrder(for: behaviour)
			),
			storage: storage, 
			predicate: configurator.predicate(for: behaviour),
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
