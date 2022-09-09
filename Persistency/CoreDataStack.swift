//
//  CoreDataStack.swift
//  GameOfThronesTests
//
//  Created by Emin on 9.09.2022.
//

import Foundation
import CoreData

/// Managing class of core data stack
/// **Note:** Such manager class shouldn't have that much public functions. It is possible to misuse those functions on upper layers.
///          Only Store classes like CategoryStore should access this. To achieve this making persistency might be the better approach.
open class CoreDataStack {
    public static let modelName = "GameOfThrones"
    
    public static let model: NSManagedObjectModel = {

        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    
    public init() {
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    
    public lazy var storeContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            //TODO: Fatal errors might be usefull for development time to see failures instantly. But we need better approach for prod.
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
    
    func saveContext() {
      saveContext(mainContext)
    }

    private func saveContext(_ context: NSManagedObjectContext) {
      if context != mainContext {
        saveDerivedContext(context)
        return
      }

      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
    }
    
    func saveDerivedContext(_ context: NSManagedObjectContext) {
      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        self.saveContext(self.mainContext)
      }
    }
}
