//
//  MenuDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.02.2024.
//

protocol MenuDelegate: AnyObject {
	func menuItemHasBeenClicked(_ item: MenuItem.Identifier)
	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool
}
