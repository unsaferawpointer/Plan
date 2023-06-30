//
//  MenuItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.06.2023.
//

import Foundation

struct MenuItem {

	let title: String

	let iconName: String?

	let keyEquivalent: String

	let action: () -> Void
}
