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
    func replace<T: Codable>(entity: String, predicate: NSPredicate, object: T) throws
    func get(entityName: String, predicate: NSPredicate?) throws -> [NSManagedObject]
    func getGeneric<T: Codable>(entityName: String, predicate: NSPredicate?) throws -> [T]
    func delete(entity: String, predicate: NSPredicate?, deleteAll: Bool) throws
}

struct CoreDataStack{
    var container: NSPersistentContainer
    var name: String?
    var context: NSManagedObjectContext?
    var description: [NSPersistentStoreDescription]?
    
    init(name: String, type: [NSPersistentStoreDescription]? = nil) {
        self.name = name
        self.container = NSPersistentContainer(name: name)
        self.description = type
        loadContainer()
        self.context = container.viewContext
    }
    
    init(persistent container: NSPersistentContainer){
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        
        self.container = container
        self.context = container.viewContext
        self.name = nil
        self.description = nil
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
            ErrorSender.sendError(error: CustomError.failedToLoadContext)
            throw CustomError.failedToLoadContext
        }
        guard let entity =  NSEntityDescription.entity(forEntityName: entity, in: context) else{
            ErrorSender.sendError(error: CustomError.failedToLoadEntity)
            throw CustomError.failedToLoadEntity
        }
        let newData = NSManagedObject(entity: entity, insertInto: context)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        let keys = Set(entity.attributesByName.keys)
        guard let filteredDict = dict?.filter({ keys.contains($0.key) }) else{
            ErrorSender.sendError(error: CustomError.noDataAvailable)
            throw CustomError.noDataAvailable
        }
        newData.setValuesForKeys(filteredDict)
        try context.save()
    }
    
    func get(entityName: String, predicate: NSPredicate? = nil) throws -> [NSManagedObject]{
        guard let context = stack.context else{
            ErrorSender.sendError(error: CustomError.failedToLoadContext)
            throw CustomError.failedToLoadContext
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate{
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        
        let result = try context.fetch(request)
        guard let result = result as? [NSManagedObject] else{
            throw CustomError.custom("Failed to get Data")
        }
        return result
    }

    func getGeneric<T: Codable>(entityName: String, predicate: NSPredicate? = nil) throws -> [T]{
        guard let context = stack.context else{
            ErrorSender.sendError(error: CustomError.failedToLoadContext)
            throw CustomError.failedToLoadContext
        }
        guard let entity =  NSEntityDescription.entity(forEntityName: entityName, in: context) else{
            ErrorSender.sendError(error: CustomError.failedToLoadEntity)
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
    
    func delete(entity: String, predicate: NSPredicate?, deleteAll: Bool = false) throws{
        guard let context = stack.context else{
            ErrorSender.sendError(error: CustomError.failedToLoadContext)
            throw CustomError.failedToLoadContext
        }

        let objects = try get(entityName: entity, predicate: predicate)
        for index in 0..<objects.count {
            let object = objects[index]
            context.delete(object)
            if index == 0 && !deleteAll{
                break
            }
        }
        try context.save()
    }
    
    func replace<T>(entity: String, predicate: NSPredicate, object: T) throws where T : Decodable, T : Encodable {
        guard let context = stack.context else{
            ErrorSender.sendError(error: CustomError.failedToLoadContext)
            throw CustomError.failedToLoadContext
        }
        let objects = try get(entityName: entity, predicate: predicate)
        if let tempObject = objects.first{
            context.delete(tempObject)
            try save(entity: entity, object: object)
        }
        try context.save()
    }

}
