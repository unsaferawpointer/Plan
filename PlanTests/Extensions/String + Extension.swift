//
//  String + Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 11.06.2023.
//

import Foundation

extension String {

	/// String from random uuid
	static var random: String {
		return UUID().uuidString
	}
}
