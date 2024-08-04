//
//  TreeNode.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 13.11.2023.
//

import Foundation

protocol TreeNode {

	associatedtype Value

	var value: Value { get }

	var children: [Self] { get }
}
