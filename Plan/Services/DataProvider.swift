//
//  DataProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import CoreData

/// App data provider interface
protocol DataProvider {

	/// Add list item to storage
	func addList(_ list: ListItem, toProject projectId: UUID?) throws

	/// Add project to storage
	func addProject(_ project: ProjectItem) throws

	/// Add task to storage
	func addTask(_ task: TaskItem, toList listId: UUID?) throws

	/// Fetch project with specific identifier
	func fetchProject(id: UUID) throws -> ProjectItem?

	/// Update project
	///
	/// - Parameters:
	///    - id: Project identifier
	///    - modification: Modification block
	func updateProject(_ id: UUID, modification: (inout ProjectItem) -> Void) throws

	/// Delete project by id
	///
	/// - Parameters:
	///    - id: Project identifier
	func deleteProject(_ id: UUID) throws

	/// Fetch list with specific identifier
	func fetchList(id: UUID) throws -> ListItem?

	/// Fetch all lists in specific project
	func fetchLists(for projectId: UUID?, sortBy sorting: [ListSorting]) throws -> [ListItem]

	/// Fetch all projects
	func fetchProjects(sortBy sorting: [ProjectSorting]) throws -> [ProjectItem]

	/// Fetch all tasks in specific list
	func fetchTasks(for listId: UUID, sortBy sorting: [TaskSorting]) throws -> [TaskItem]

	/// Save changes
	func save() throws
}
