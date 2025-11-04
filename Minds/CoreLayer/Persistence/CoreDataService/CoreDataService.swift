//
//  CoreDataService.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.10.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    
    func fetch<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>) async throws -> [T]
        
    func save(_ block: @escaping (NSManagedObjectContext) throws -> Void) async throws
    
    func delete(with id: UUID) async throws
}

final class CoreDataService {
    
    private let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Mind")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

// MARK: - CoreDataServiceProtocol

extension CoreDataService: CoreDataServiceProtocol {
    
    func fetch<T: NSManagedObject>(
        fetchRequest: NSFetchRequest<T>
    ) async throws -> [T] where T : NSManagedObject {
        try await viewContext.perform {
            try self.viewContext.fetch(fetchRequest)
        }
    }
    
    func save(_ block: @escaping (NSManagedObjectContext) throws -> Void) async throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        try await backgroundContext.perform {
            try block(backgroundContext)
            if backgroundContext.hasChanges {
                try backgroundContext.save()
            }
        }
    }
    
    func delete(with id: UUID) async throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        try await backgroundContext.perform {
            let fetchRequest = MindDB.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let mind = try backgroundContext.fetch(fetchRequest)
            mind.forEach { backgroundContext.delete($0) }
            if backgroundContext.hasChanges {
                try backgroundContext.save()
            }
        }
    }
}
