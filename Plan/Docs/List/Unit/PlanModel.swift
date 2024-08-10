//
//  PlanModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

enum PlanModel {
	case placeholder(title: String, subtitle: String)
	case regular(snapshot: HierarchySnapshot, status: BottomBar.Model)
}
