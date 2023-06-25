//
//  Primary.Assembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

extension Primary {

	final class Assembly {

		func build() -> NSViewController {
			let presenter = Primary.Presenter()
			let interactor = Primary.Interactor(dataProvider: CoreDataProvider(persistentContainer: nil))
			return Primary.ViewController { viewController in
				presenter.view = viewController
				viewController.output = presenter
				presenter.interactor = interactor
				interactor.presenter = presenter
			}
		}
	}
}
