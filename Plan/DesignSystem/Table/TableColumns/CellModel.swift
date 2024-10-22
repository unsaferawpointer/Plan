//
//  CellModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 05.09.2024.
//

protocol CellModel {

	associatedtype Value

	associatedtype Configuration

	var configuration: Configuration { get }

	var value: Value { get }
}
