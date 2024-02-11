//
//  SidebarPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol SidebarPresenterProtocol: AnyObject {
	func present(_ projects: [Project])
}

final class SidebarPresenter {

	var stateProvider: SidebarStateProviderProtocol

	var interactor: SidebarInteractorProtocol?

	weak var titleDelegate: TitleDelegate?

	weak var view: SidebarView?

	// MARK: - Initialization

	init(
		stateProvider: SidebarStateProviderProtocol,
		titleDelegate: TitleDelegate
	) {
		self.stateProvider = stateProvider
		self.titleDelegate = titleDelegate
	}
}

// MARK: - SidebarPresenterProtocol
extension SidebarPresenter: SidebarPresenterProtocol {

	func present(_ projects: [Project]) {

		let staticContent: [SidebarItem] =
		[
			.init(id: .inbox, icon: "tray.fill", title: "Inbox"),
			.init(id: .backlog, icon: "square.stack.3d.up.fill", title: "Backlog"),
			.init(id: .archieve, icon: "shippingbox.fill", title: "Archieve")
		]

		let dynamicContent = projects.map { project in
			SidebarItem(
				id: .project(project.uuid),
				icon: "doc.text",
				title: project.title
			)
		}

		view?.display(
			staticContent: staticContent,
			sectionTitle: "Lists",
			dynamicContent: dynamicContent
		)
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}

		do {
			try interactor?.fetchProjects()
		} catch {
			// TODO: - Handle action
		}

		let route = stateProvider.getRoute()
		view?.selectItem(route)
	}

	func selectionDidChange(_ newValue: SidebarItem) {
		stateProvider.navigate(to: newValue.id)
		titleDelegate?.titleDidChange(newValue.title)
	}
}
