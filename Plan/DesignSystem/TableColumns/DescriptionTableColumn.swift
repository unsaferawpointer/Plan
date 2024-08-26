//
//  DescriptionTableColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Cocoa

struct DescriptionTableColumn: TableColumn {

	typealias Value = PlanItemModel

	typealias Model = HierarchyModel

	typealias Cell = PlanItemCell

	var keyPath: KeyPath<Model, Value>

	var identifier: String = "description_table_column"

	var title: String = "Description"

	var action: ((UUID, PlanItemModel) -> Void)?
}
