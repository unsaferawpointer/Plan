//
//  SidebarPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

final class SidebarPresenter {

	var stateProvider: SidebarStateProviderProtocol

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

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}

		switch stateProvider.getRoute() {
		case .focus:
			view?.selectItem(.focus)
		case .backlog:
			view?.selectItem(.backlog)
		case .favorites:
			view?.selectItem(.favorites)
		case .projects:
			view?.selectItem(.projects)
		case .archieve:
			view?.selectItem(.archieve)
		}
	}

	func selectionDidChange(_ newValue: SidebarItem) {
		switch newValue {
		case .focus:		stateProvider.navigate(to: .focus)
		case .backlog:		stateProvider.navigate(to: .backlog)
		case .favorites:	stateProvider.navigate(to: .favorites)
		case .projects:		stateProvider.navigate(to: .projects)
		case .archieve:		stateProvider.navigate(to: .archieve)
		}
		titleDelegate?.titleDidChange(newValue.title)
	}
}
