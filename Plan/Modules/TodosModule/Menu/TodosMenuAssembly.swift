//
//  TodosMenuAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Cocoa

final class TodosMenuAssembly {

	static func assemble(output: MenuDelegate) -> NSMenu {
		let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		let provider = ListsDataProvider(context: context!)
		let presenter = TodosMenuPresenter(provider: provider)
		presenter.output = output
		let menu = TodosContextMenu()
		menu.output = presenter
		presenter.menu = menu
		return menu
	}
}
