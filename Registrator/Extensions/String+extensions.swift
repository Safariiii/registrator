//
//  String+extensions.swift
//  Registrator
//
//  Created by Denis Khlopin on 02.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

extension String {
    var isBackspace: Bool {
        if let char = self.cString(using: .utf8) {
            return strcmp(char, "\\b") == spaceCode
        }
        return false
    }
}
