//
//  SidebarPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

final class SidebarPresenter {

	var stateProvider: SidebarStateProviderProtocol

	// MARK: - Initialization

	init(stateProvider: SidebarStateProviderProtocol) {
		self.stateProvider = stateProvider
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func selectionDidChange(_ newValue: SidebarItem) {
		switch newValue {
		case .focus:		stateProvider.navigate(to: .focus)
		case .backlog:		stateProvider.navigate(to: .backlog)
		case .favorites:	stateProvider.navigate(to: .favorites)
		case .projects:		stateProvider.navigate(to: .projects)
		case .archieve:		stateProvider.navigate(to: .archieve)
		}
	}
}
