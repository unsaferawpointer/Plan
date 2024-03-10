//
//  MenuSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Cocoa

@objc
protocol MenuSupportable {

	@objc
	func menuItemHasBeenClicked(_ sender: NSMenuItem)
}
