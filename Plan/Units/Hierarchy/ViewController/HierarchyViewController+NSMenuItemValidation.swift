//
//  HierarchyViewController+NSMenuItemValidation.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

// MARK: - NSMenuItemValidation
extension HierarchyViewController: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

		guard let adapter else {
			return false
		}

		switch menuItem.action {
		case .createNew:
			return true
		case .redo:
			return output?.canRedo() ?? false
		case .undo:
			return output?.canUndo() ?? false
		case .cut, .copy, .fold, .unfold, .delete, .setColor:
			return !table.effectiveSelection().isEmpty
		case .paste:
			return output?.canPaste() ?? false
		case .toggleCompleted, .toggleBookmarked:

			if let id = menuItem.identifier?.rawValue {
				let state = adapter.menuItemState(for: id)
				menuItem.state = state
			}

			return !table.effectiveSelection().isEmpty
		default:
			break
		}

		guard let identifier = menuItem.identifier else {
			return false
		}

		switch identifier {
		case
			 .setEstimationMenuItem,
			 .setIconMenuItem,
			 .iconsGroupMenuItem,
			 .setPriorityMenuItem:
			return !table.effectiveSelection().isEmpty
		default:
			break
		}
		let state = adapter.menuItemState(for: identifier.rawValue)
		menuItem.state = state

		return adapter.validateMenuItem(identifier.rawValue)
	}
}
