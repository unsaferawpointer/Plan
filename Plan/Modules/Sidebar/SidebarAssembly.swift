//
//  SidebarAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarAssembly {

	static func assemble(stateProvider: SidebarStateProviderProtocol) -> NSViewController {
		let presenter = SidebarPresenter(stateProvider: stateProvider)
		return SidebarViewController { viewController in
			viewController.output = presenter
			presenter.view = viewController
		}
	}
}
