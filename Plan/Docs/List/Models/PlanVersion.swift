//
//  PlanVersion.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.08.2024.
//

import Foundation

/// Version of a document file
enum PlanVersion: String {
	case v1
}

// MARK: - CaseIterable
extension PlanVersion: CaseIterable { }

// MARK: - Comparable
extension PlanVersion: Comparable {

	static func < (lhs: PlanVersion, rhs: PlanVersion) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}
