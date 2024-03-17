//
//  SidebarAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarAssembly {

	static func assemble(
		stateProvider: SidebarStateProviderProtocol,
		titleDelegate: TitleDelegate
	) -> NSViewController {
		let presenter = SidebarPresenter(
			stateProvider: stateProvider,
			itemsFactory: SidebarItemFactory(),
			titleDelegate: titleDelegate
		)
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let storage = PersistentContainer(context: context!)
		let interactor = SidebarInteractor(provider: ListsDataProvider(context: context!), storage: storage)

		let menu = SidebarMenuAssembly.assemble(delegate: presenter)

		return SidebarViewController(menu) { viewController in
			viewController.output = presenter
			presenter.view = viewController
			interactor.presenter = presenter
			presenter.interactor = interactor
		}
	}
}
