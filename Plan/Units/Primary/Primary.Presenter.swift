//
//  Primary.Presenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

import Foundation

/// Primary unit presenter interface
protocol PrimaryPresenter: AnyObject {

	/// Present projects
	func present(_ projects: [ProjectItem])
}

extension Primary {

	/// Primary unit presenter
	final class Presenter {

		var interactor: PrimaryInteractor?

		weak var view: PrimaryView?

		var localization: PrimaryLocalization

		// MARK: - Localization

		/// Basic localization
		///
		/// - Parameters:
		///    - localization: Unit localization
		init(localization: PrimaryLocalization = Primary.Localization()) {
			self.localization = localization
		}

	}
}

// MARK: - ViewControllerOutput
extension Primary.Presenter: ViewControllerOutput {

	func viewControllerDidChangeState(_ newState: ViewControllerState) {
		guard case .viewDidLoad = newState, let interactor else {
			return
		}
		do {
			try interactor.fetchProjects(sortBy: [.creationDate(), .name()])
		} catch {
			// TODO: - Handle error
		}
	}
}

// MARK: - PrimaryPresenter
extension Primary.Presenter: PrimaryPresenter {

	func present(_ projects: [ProjectItem]) {
		let basicSection = makeBasicSection()
		let projectsSection = makeProjectsSection(projects) { [weak self] id, name in
			guard let self else {
				return
			}
			do {
				try self.interactor?.renameProject(id: id, newName: name)
			} catch {
				// TODO: - Handle errors
			}
		}
		view?.display([basicSection, projectsSection])
	}
}

// MARK: - Items creation
private extension Primary.Presenter {

	func makeProjectsSection(_ projects: [ProjectItem], textDidChange: @escaping (UUID, String) -> Void) -> Primary.SectionModel {
		let projectItems = makeProjectsItems(projects, textDidChange: textDidChange)
		let button = HeaderConfiguration.Button(title: localization.addProjectButtonTitle) { [weak self] in
			guard let self else {
				return
			}
			let project = ProjectItem(name: self.localization.defaultProjectName)
			do {
				try self.interactor?.addProject(project)
			} catch {
				// TODO: - Handle error
			}
		}
		return Primary.SectionModel(id: .projects, content: .init(title: "Projects", button: button), items: projectItems)
	}

	func makeProjectsItems(_ projects: [ProjectItem], textDidChange: @escaping (UUID, String) -> Void) -> [Primary.ItemModel] {
		return projects.map { project in
			let content = LabelConfiguration.project(title: project.name) { text in
				textDidChange(project.uuid, text)
			}
			return Primary.ItemModel(id: Navigation.project(project.uuid), tintColor: .gray, content: content)
		}
	}

	func makeBasicSection() -> Primary.SectionModel {
		return Primary.SectionModel(
			id: .basic,
			content: .init(title: "Basic"),
			items: makeBasicItems()
		)
	}

	func makeBasicItems() -> [Primary.ItemModel] {
		return [.init(
					id: Navigation.all,
					tintColor: .gray,
					content: .init(title: localization.allItem,
								   iconName: "app")
				),
				.init(
					id: Navigation.favorite,
					tintColor: .yellow,
					content: .init(title: localization.favoriteItem,
								   iconName: "star.fill")
				)]
	}
}

private extension LabelConfiguration {

	static func project(title: String,
						textDidChange: @escaping (String) -> Void) -> LabelConfiguration {
		return .init(
			title: title,
			iconName: "doc.plaintext.fill",
			isEditable: true,
			titleDidChange: textDidChange
		)
	}
}
