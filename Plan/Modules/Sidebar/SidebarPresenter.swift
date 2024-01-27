//
//  SidebarPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

final class SidebarPresenter {

	weak var output: SidebarOutput?

	// MARK: - Initialization

	init(output: SidebarOutput? = nil) {
		self.output = output
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func selectionDidChange(_ newValue: SidebarItem) {
		switch newValue {
		case .focus:		output?.navigationDidChange(.focus)
		case .backlog:		output?.navigationDidChange(.backlog)
		case .favorites:	output?.navigationDidChange(.favorites)
		case .projects:		output?.navigationDidChange(.projects)
		}
	}
}
