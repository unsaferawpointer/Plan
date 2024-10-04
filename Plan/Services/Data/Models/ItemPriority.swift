//
//  ItemPriority.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.10.2024.
//

import Foundation

enum ItemPriority: Int {
	case low = 0
	case medium
	case high
}

// MARK: - Codable
extension ItemPriority: Codable { }

// MARK: - CaseIterable
extension ItemPriority: CaseIterable { }
