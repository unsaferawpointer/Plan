//
//  SidebarMenuAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.02.2024.
//

import Cocoa

final class SidebarMenuAssembly {

	static func assemble(delegate: MenuDelegate) -> NSMenu {
		return SidebarContextMenu(delegate: delegate, localization: SidebarMenuLocalization())
	}
}
