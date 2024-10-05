//
//  DocumentType.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.08.2024.
//

import Foundation

enum DocumentType: String {
	case plan = "dev.zeroindex.plan"
}

// MARK: - Computed properties
extension DocumentType {

	var lastVersion: Version {
		switch self {
		case .plan:
			return .init(major: 1)
		}
	}
}
