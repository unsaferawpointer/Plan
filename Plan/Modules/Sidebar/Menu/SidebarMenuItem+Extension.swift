//
//  SidebarMenuItem+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import Foundation

extension MenuItem {

	static var newList: MenuItem {
		let title = String(localized: "new_list")
		return .custom(.newList, content: .init(title: title, keyEquivalent: "N"))
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "SidebarMenuLocalizable")
	}
}
