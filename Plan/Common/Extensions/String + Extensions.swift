//
//  String + Extensions.swift
//  Plan
//
//  Created by Anton Cherkasov on 24.06.2023.
//

import AppKit

extension String {

	func localized(tableName: String) -> String {
		return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: "")
	}
}
