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
		let interactor = ProjectsInteractor()
		return ProjectsViewController { viewController in
			viewController.output = presenter
			presenter.interactor = interactor
			interactor.presenter = presenter
			presenter.view = viewController
		}
	}
}
