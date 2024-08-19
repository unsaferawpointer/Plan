//
//  TreeNode.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 13.11.2023.
//

import Foundation

protocol TreeNode<Value> {

	associatedtype Value: Identifiable

	var value: Value { get }

	var children: [Self] { get }
}

extension TreeNode {

	var id: Value.ID {
		value.id
	}
}
