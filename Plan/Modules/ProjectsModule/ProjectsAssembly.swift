//
//  ProjectsAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class ProjectsAssembly {

	static func assemble() -> NSViewController {
		let presenter = ProjectsPresenter()
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let interactor = ProjectsInteractor(
			presenter: presenter,
			provider: ProjectsDataProvider(context: context!),
			storage: storage
		)

		return ProjectsViewController { viewController in
			viewController.output = presenter
			presenter.interactor = interactor
			presenter.view = viewController
		}
	}
}
