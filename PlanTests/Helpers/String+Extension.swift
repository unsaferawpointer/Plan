//
//  String+Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

import Foundation

extension String {

	static var random: String {
		return UUID().uuidString
	}
}
