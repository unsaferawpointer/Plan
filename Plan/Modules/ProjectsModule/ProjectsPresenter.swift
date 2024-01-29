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
		let models = projects.map {
			makeConfiguration(from: $0)
		}

		view?.display(models)
	}
}

// MARK: - ProjectsViewOutput
extension ProjectsPresenter: ProjectsViewOutput {

	func labelDidChange(text newValue: String, for id: UUID) {
		do {
			try interactor?.setTitle(newValue, with: id)
		} catch {
			// TODO: - Handle errors
		}
	}

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState, let interactor else {
			return
		}

		do {
			try interactor.fetchProjects()
		} catch {
			// TODO: - Handle errors
		}
	}

	func selectionDidChange(_ newValue: [UUID]) {
		// TODO: - Handle action
	}

	func toolbarNewProjectButtonHasBeenClicked() {
		do {
			try interactor?.createProject(withTitle: "New project")
		} catch {
			// TODO: - Handle errors
		}
	}
}

// MARK: - Helpers
private extension ProjectsPresenter {

	func makeConfiguration(from project: Project) -> ProjectConfiguration {
		return ProjectConfiguration(
			uuid: project.uuid,
			title: project.title,
			subtitle: "\(project.count) items",
			countLabel: nil
		)
	}
}
