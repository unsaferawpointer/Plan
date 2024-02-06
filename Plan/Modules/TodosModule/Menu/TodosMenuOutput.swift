//
//  TodosMenuOutput.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

protocol TodosMenuOutput: AnyObject {
	func menuItemHasBeenClicked(_ item: TodosMenuItemIdentifier)
}
