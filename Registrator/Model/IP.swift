//
//  IP.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import RealmSwift

class Class: Object {
    @objc dynamic var code: String?
    @objc dynamic var descr: String?
    override static func primaryKey() -> String? {
        return "code"
    }
    
    let codes = List<Code>() // устанавливаем связь между категорией и конкретными элементами, входящими в эту категорию.
}

class Code: Object {
    @objc dynamic var code: String?
    @objc dynamic var descr: String?
    @objc dynamic var parentClassCode: String?
    
    var parentClass = LinkingObjects(fromType: Class.self, property: "codes") // устанавливаем связь между категорией и конкретными элементами, входящими в эту категорию.
    
    
    
}
