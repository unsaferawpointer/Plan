//
//  TodosMenuDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

protocol TodosMenuDelegate: AnyObject {
	func menuItemHasBeenClicked(_ item: MenuItem.Identifier)
	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool
}
