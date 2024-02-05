//
//  InfoDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 05.02.2024.
//

import Foundation

protocol InfoDelegate: AnyObject {
	func infoDidChange(_ info: String)
}
