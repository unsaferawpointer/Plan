//
//  IconModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.10.2024.
//

import Foundation

struct IconModel: CellModel {

	var value: Value
	var configuration: Configuration
}

// MARK: - Nested data structs
extension IconModel {

	struct Configuration {
		var color: Color?
	}

	struct Value {
		var icon: IconName?
	}
}
