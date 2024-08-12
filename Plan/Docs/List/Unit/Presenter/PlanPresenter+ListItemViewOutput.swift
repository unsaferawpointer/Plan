//
//  PlanPresenter+ListItemViewOutput.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import Foundation

// MARK: - ListItemViewOutput
extension PlanPresenter: ListItemViewOutput {

	func textfieldDidChange(_ id: UUID, newText: String) {
		interactor?.textDidChange(id, newText: newText)
	}

	func checkboxDidChange(_ id: UUID, newValue: Bool) {
		interactor?.statusDidChange(id, newValue: newValue)
	}
}
