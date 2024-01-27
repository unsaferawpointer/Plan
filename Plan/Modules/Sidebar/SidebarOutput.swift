//
//  SidebarOutput.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol SidebarOutput: AnyObject {
	func navigationDidChange(_ item: Route)
}
