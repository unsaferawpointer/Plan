//
//  SidebarAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarAssembly {

	static func assemble(_ output: SidebarOutput) -> NSViewController {
		let presenter = SidebarPresenter(output: output)
		return SidebarViewController { viewController in
			viewController.output = presenter
		}
	}
}
