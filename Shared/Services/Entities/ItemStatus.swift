//
//  ItemStatus.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

enum ItemStatus {
	case open
	case todo
	case inProgress(start: Date)
	case done(completed: Date)
}

// MARK: - Computed properties
extension ItemStatus {

	var completionDate: Date? {
		switch self {
		case .done(let completed):
			return completed
		default:
			return nil
		}
	}
}

// MARK: - Codable
extension ItemStatus: Codable { }

// MARK: - Hashable
extension ItemStatus: Hashable { }
