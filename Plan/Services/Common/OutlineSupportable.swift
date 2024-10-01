//
//  OutlineSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.10.2024.
//

import Foundation

protocol OutlineSupportable: TableSupportable {
	func expand(_ ids: [UUID])
	func expandAll()
	func collapse(_ ids: [UUID])
}
