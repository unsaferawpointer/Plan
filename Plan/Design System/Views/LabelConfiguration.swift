//
//  LabelConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.01.2024.
//

import Foundation

struct LabelConfiguration: ViewConfiguration {

	typealias View = LabelView

	var title: String?

	var titleDidChange: ((String) -> Void)?
}
