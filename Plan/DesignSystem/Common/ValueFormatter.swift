//
//  ValueFormatter.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.09.2024.
//

import AppKit

final class ValueFormatter: NumberFormatter {

	override func isPartialStringValid(
		_ partialString: String,
		newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
		errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
	) -> Bool {
		return partialString.isEmpty || Int(partialString) != nil
	}
}
