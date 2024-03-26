//
//  SidebarAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarAssembly {

	static func assemble(
		settingsProvider: SidebarSettingsProviderProtocol,
		titleDelegate: TitleDelegate
	) -> NSViewController {
		let presenter = SidebarPresenter(
			settingsProvider: settingsProvider,
			itemsFactory: SidebarItemFactory(localization: SidebarLocalization()),
			titleDelegate: titleDelegate
		)
		let context = PersistentContainer.shared.mainContext
		let storage = DataStorage(context: context)
		let interactor = SidebarInteractor(provider: ListsDataProvider(context: context), storage: storage)

		let menu = SidebarMenuAssembly.assemble(delegate: presenter)

		return SidebarViewController(menu) { viewController in
			viewController.output = presenter
			presenter.view = viewController
			interactor.presenter = presenter
			presenter.interactor = interactor
		}
	}
}
