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

// MARK: - Computed properties
extension ItemStatus {

	var completionDate: Date? {
		switch self {
		case .open:
			return nil
		case .done(let completed):
			return completed
		}
	}
}

// MARK: - Codable
extension ItemStatus: Codable { }

// MARK: - Hashable
extension ItemStatus: Hashable { }
