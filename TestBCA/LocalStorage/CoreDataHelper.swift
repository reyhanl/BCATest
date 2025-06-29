//
//  CoreDataHelper.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import CoreData

protocol CoreDataHelperProtocol{
    var stack: CoreDataStack{get set}
    func save<T: Codable>(entity: String, object: T) throws
    func get(entityName: String, predicate: NSPredicate?) throws -> [NSManagedObject]?
    func getGeneric<T: Codable>(entityName: String, predicate: NSPredicate?) throws -> [T]?
    func delete(entity: String, predicate: NSPredicate, deleteAll: Bool) throws
}

struct CoreDataStack{
    var container: NSPersistentContainer
    var name: String
    var context: NSManagedObjectContext?
    var description: [NSPersistentStoreDescription]?
    
    init(name: String, type: [NSPersistentStoreDescription]? = nil) {
        self.name = name
        self.container = NSPersistentContainer(name: name)
        self.description = type
        loadContainer()
        self.context = container.viewContext
    }
    
    func loadContainer(){
        if let description = UserDefaults.standard.string(forKey: "testing"){
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        if let description = description{
            container.persistentStoreDescriptions = description
        }
        container.loadPersistentStores { _, error in
            if let error = error{
                fatalError(error.localizedDescription)
            }
        }
    }
}

struct CoreDataHelper: CoreDataHelperProtocol{
    
    var stack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    func save<T: Codable>(entity: String, object: T) throws{
        guard let context = stack.context else{
            throw CustomError.failedToLoadContext
        }
        guard let entity =  NSEntityDescription.entity(forEntityName: entity, in: context) else{
            throw CustomError.failedToLoadEntity
        }
        let newData = NSManagedObject(entity: entity, insertInto: context)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        let keys = Set(entity.attributesByName.keys)
        guard let filteredDict = dict?.filter({ keys.contains($0.key) }) else{
            throw CustomError.custom("")
            return
        }
        newData.setValuesForKeys(filteredDict)
        try context.save()
    }
    
    func get(entityName: String, predicate: NSPredicate? = nil) throws -> [NSManagedObject]?{
        guard let context = stack.context else{
            throw CustomError.failedToLoadContext
        }
        guard let entity =  NSEntityDescription.entity(forEntityName: entityName, in: context) else{
            throw CustomError.failedToLoadEntity
        }
        let newData = NSManagedObject(entity: entity, insertInto: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        
        let result = try context.fetch(request)
        return result as? [NSManagedObject]
    }

    func getGeneric<T: Codable>(entityName: String, predicate: NSPredicate? = nil) throws -> [T]?{
        guard let context = stack.context else{
            throw CustomError.failedToLoadContext
        }
        guard let entity =  NSEntityDescription.entity(forEntityName: entityName, in: context) else{
            throw CustomError.failedToLoadEntity
        }
        let newData = NSManagedObject(entity: entity, insertInto: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        
        let result = try context.fetch(request)
        let data = result.compactMap {
            $0 as? NSManagedObject
        }.compactMap {
            try? JSONDecoder().decode(
                T.self,
                from: try JSONSerialization.data(
                    withJSONObject: (
                        $0
                    ).dictionaryWithValues(
                        forKeys: Array(
                            $0.entity.attributesByName.keys
                        )
                    ),
                    options: []
                )
            )
        }
        return data
    }
    
    func delete(entity: String, predicate: NSPredicate, deleteAll: Bool = false) throws{
        guard let context = stack.context else{
            throw CustomError.failedToLoadContext
        }

        guard let objects = try get(entityName: entity) else{
            throw CustomError.custom("No Data to Delete")
        }
        
        for index in 0..<objects.count {
            let object = objects[index]
            context.delete(object)
            if index == 0 && deleteAll{
                break
            }
        }
        try context.save()
    }

}
