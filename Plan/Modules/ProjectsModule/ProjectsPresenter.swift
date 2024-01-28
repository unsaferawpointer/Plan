//
//  ProjectsPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol ProjectsPresenterProtocol: AnyObject {
	func present(_ projects: [Project])
}

final class ProjectsPresenter {

	weak var view: ProjectsView?

	var interactor: ProjectsInteractorProtocol?
}

// MARK: - ProjectsPresenterProtocol
extension ProjectsPresenter: ProjectsPresenterProtocol {

	func present(_ projects: [Project]) {
		// TODO: - Handle action
	}
}

// MARK: - ProjectsViewOutput
extension ProjectsPresenter: ProjectsViewOutput {

	func labelDidChange(text newValue: String, for id: UUID) {
		// TODO: - Handle action
	}

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState, let interactor else {
			return
		}

		do {
			let projects = try interactor.fetchProjects()

			let models = projects.map {
				makeConfiguration(from: $0)
			}

			view?.display(models)
		} catch {
			// TODO: - Handle errors
		}
	}

	func selectionDidChange(_ newValue: [UUID]) {
		// TODO: - Handle action
	}
}

// MARK: - Helpers
private extension ProjectsPresenter {

	func makeConfiguration(from project: Project) -> ProjectConfiguration {
		return ProjectConfiguration(
			uuid: project.uuid,
			title: project.name,
			subtitle: "\(project.count) items",
			countLabel: nil
		)
	}
}
