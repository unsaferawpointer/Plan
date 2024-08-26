//
//  PlanItemModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Foundation

struct PlanItemModel {

	var isOn: Bool?

	var text: String

	var textColor: Color

	var icon: String?

	var iconColor: Color?
}

extension PlanItemModel {

	var checkboxIsHidden: Bool {
		return isOn == nil
	}

	var imageIsHidden: Bool {
		return icon == nil
	}
}
