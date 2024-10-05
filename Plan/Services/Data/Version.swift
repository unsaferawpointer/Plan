//
//  Version.swift
//  Plan
//
//  Created by Anton Cherkasov on 05.10.2024.
//

import Foundation

/// - Note: **format** `major.minor.patch`
struct Version {

	let major: Int
	let minor: Int
	let patch: Int

	init(major: Int, minor: Int = 0, patch: Int = 0) {
		self.major = major
		self.minor = minor
		self.patch = patch
	}

}

// MARK: - RawRepresentable
extension Version: RawRepresentable {

	var rawValue: String {
		return "\(major).\(minor).\(patch)"
	}

	init?(rawValue: String) {

		let modificated = rawValue.trimmingPrefix("v")

		let components = modificated.split(separator: ".")
		guard let majorComponent = components.first, let major = Int(majorComponent) else {
			return nil
		}

		self.major = major

		if let minorComponent = components[optional: 1] {
			self.minor = Int(minorComponent) ?? 0
		} else {
			self.minor = 0
		}

		if let patchComponent = components[optional: 2] {
			self.patch = Int(patchComponent) ?? 0
		} else {
			self.patch = 0
		}
	}
}

// MARK: - Codable
extension Version: Codable { }

// MARK: - Comparable
extension Version: Comparable {

	static func < (lhs: Version, rhs: Version) -> Bool {
		[(lhs.major, rhs.major), (lhs.minor, rhs.minor), (lhs.patch, rhs.patch)]
			.compactMap { lhs, rhs in
				compare(lhs: lhs, rhs: rhs)
			}.first ?? false
	}

	static func compare(lhs: Int, rhs: Int) -> Bool? {
		guard lhs != rhs else {
			return nil
		}
		return lhs < rhs
	}
}
