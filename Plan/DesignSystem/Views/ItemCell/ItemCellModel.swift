//
//  ItemCellModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Foundation

struct ItemCellModel: CellModel {

	var value: Value

	var configuration: Configuration
}

extension ItemCellModel {

	var checkboxIsHidden: Bool {
		return value.isOn == nil
	}

	var imageIsHidden: Bool {
		return configuration.icon == nil
	}
}

extension ItemCellModel {

	struct Value {
		var isOn: Bool?
		var text: String
	}

	struct Configuration {
		var textColor: Color
		var icon: String?
		var iconColor: Color?
	}
}
