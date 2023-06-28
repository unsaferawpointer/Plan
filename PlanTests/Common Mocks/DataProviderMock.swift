//
//  DataProviderMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.06.2023.
//

import Foundation
@testable import Plan

final class DataProviderMock {

	var invocations: [Action] = []

	var stubs: Stubs = .init()
}

// MARK: - DataProvider
extension DataProviderMock: DataProvider {

	func updateProject(_ id: UUID, modification: (inout ProjectItem) -> Void) throws {
		invocations.append(.updateProject(id))
		modification(&stubs.updatedProject)
	}

	func addList(_ list: ListItem, toProject projectId: UUID?) throws {
		invocations.append(.addList(list, projectId: projectId))
	}

	func addProject(_ project: ProjectItem) throws {
		invocations.append(.addProject(project))
	}

	func addTask(_ task: TaskItem, toList listId: UUID?) throws {
		invocations.append(.addTask(task, listId: listId))
	}

	func fetchProject(id: UUID) throws -> ProjectItem? {
		invocations.append(.fetchProject(id: id))
		return stubs.fetchProject
	}

	func fetchList(id: UUID) throws -> ListItem? {
		invocations.append(.fetchList(id: id))
		return stubs.fetchList
	}

	func fetchLists(for projectId: UUID?, sortBy sorting: [ListSorting]) throws -> [ListItem] {
		invocations.append(.fetchLists(projectId: projectId, sorting: sorting))
		return stubs.fetchLists
	}

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws -> [ProjectItem] {
		invocations.append(.fetchProjects(sorting: sorting))
		return stubs.fetchProjects
	}

	func fetchTasks(for listId: UUID, sortBy sorting: [TaskSorting]) throws -> [TaskItem] {
		invocations.append(.fetchTasks(listId: listId, sorting: sorting))
		return stubs.fetchTasks
	}

	func save() throws {
		invocations.append(.save)
	}

}

// MARK: - Nested Data structs
extension DataProviderMock {

	enum Action {
		case addList(_ list: ListItem, projectId: UUID?)
		case addProject(_ project: ProjectItem)
		case updateProject(_ id: UUID)
		case addTask(_ task: TaskItem, listId: UUID?)
		case fetchProject(id: UUID)
		case fetchList(id: UUID)
		case fetchLists(projectId: UUID?, sorting: [ListSorting])
		case fetchProjects(sorting: [ProjectSorting])
		case fetchTasks(listId: UUID, sorting: [TaskSorting])
		case save
	}

	struct Stubs {
		var fetchProject: ProjectItem? = nil
		var fetchList: ListItem? = nil
		var fetchLists: [ListItem] = []
		var fetchProjects: [ProjectItem] = []
		var fetchTasks: [TaskItem] = []
		var updatedProject: ProjectItem = .init(name: .random)
	}
}
