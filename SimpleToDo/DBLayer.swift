//
//  DBLayer.swift
//  SimpleToDo
//
//  Created by Milad on 5/27/23.
//

import Foundation
import RealmSwift

class TodoObject: Object {
    @Persisted var title: String = ""
    @Persisted var descriptionNote: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var index = 0
}

class DBHelper {
    
    public static func RealmThread(_ block: @escaping ()->Void) {
        DispatchQueue(label: "RealmSwift").async(execute: block)
    }
    
    public static func write(object: Object, completed: (()->Void)? = nil) {
        RealmThread {
            let realm = try! Realm()
            try! realm.write {
                realm.add(object)
            }
        }
        completed?()
    }
    
    public static func read(_ completion: @escaping ([TodoObject])->Void) {
        Utilities.UI {
            let realm = try! Realm()
            let objects = realm.objects(TodoObject.self)
            completion(Array(objects))
        }
    }
    public static func readCompleted(_ completion: @escaping ([TodoObject])->Void) {
        Utilities.UI {
            let realm = try! Realm()
            let objects = realm.objects(TodoObject.self).where { obj in
                obj.isCompleted == true
            }
            completion(Array(objects))
        }
    }
    public static func readTodo(_ completion: @escaping ([TodoObject])->Void) {
        Utilities.UI {
            let realm = try! Realm()
            let objects = realm.objects(TodoObject.self).where { obj in
                obj.isCompleted == false
            }
            completion(Array(objects))
        }
    }
    
    public static func delete(object: Object) {
        RealmThread {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    public static func realmBlock(_ block: @escaping ()->Void) {
        Utilities.UI {
            let realm = try! Realm()
            try! realm.write {
                block()
            }
        }
    }
}

class Utilities {
    public static func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    public static func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
}
