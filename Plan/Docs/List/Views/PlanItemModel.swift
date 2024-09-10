//
//  PlanItemModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Foundation

struct PlanItemModel: CellModel {

	var value: Value

	var configuration: Configuration
}

extension PlanItemModel {

	var checkboxIsHidden: Bool {
		return value.isOn == nil
	}

	var imageIsHidden: Bool {
		return configuration.icon == nil
	}
}

extension PlanItemModel {

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
