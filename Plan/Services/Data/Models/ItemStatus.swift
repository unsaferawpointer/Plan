//
//  ItemStatus.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

enum ItemStatus {
	case open
	case done(completed: Date)
}

// MARK: - Codable
extension ItemStatus: Codable { }

// MARK: - Hashable
extension ItemStatus: Hashable { }
