//
//  PlanViewController+NSMenuItemValidation.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

// MARK: - NSMenuItemValidation
extension PlanViewController: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let identifier = menuItem.identifier, let adapter else {
			return false
		}

		switch identifier {
		case .redoMenuItem:
			return output?.canRedo() ?? false
		case .undoMenuItem:
			return output?.canUndo() ?? false
		case .newMenuItem,
				.setEstimationMenuItem,
				.setIconMenuItem,
				.iconsGroupMenuItem:
			return true
		case .pasteMenuItem:
			return output?.canPaste() ?? false
		case .foldMenuItem, .unfoldMenuItem, .cutMenuItem, .copyMenuItem:
			return !adapter.selection.isEmpty
		default:
			break
		}
		let state = adapter.menuItemState(for: identifier.rawValue)
		menuItem.state = state

		return adapter.validateMenuItem(identifier.rawValue)
	}
}
