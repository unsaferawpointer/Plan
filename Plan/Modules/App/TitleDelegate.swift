//
//  TitleDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 05.02.2024.
//

import Foundation

protocol TitleDelegate: AnyObject {
	func titleDidChange(_ title: String)
}
