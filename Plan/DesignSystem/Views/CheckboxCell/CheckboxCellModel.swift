//
//  CheckboxCellModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Foundation

struct CheckboxCellModel: CellModel {

	var value: Value

	var configuration: Configuration
}

extension CheckboxCellModel {

	struct Value: Equatable {
		var isOn: Bool
	}

	struct Configuration: Equatable { }
}

// MARK: - Equatable
extension CheckboxCellModel: Equatable { }
