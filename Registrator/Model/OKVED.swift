//
//  OKVED.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 18.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import RealmSwift

struct OKVED {
    let kod: String
    let descr: String
}

class Class: Object {
    @objc dynamic var code: String?
    @objc dynamic var descr: String?
    override static func primaryKey() -> String? {
        return "code"
    }
    let codes = List<Code>()
}

class Code: Object {
    @objc dynamic var code: String?
    @objc dynamic var descr: String?
    @objc dynamic var parentClassCode: String?
    var parentClass = LinkingObjects(fromType: Class.self, property: "codes")
}
