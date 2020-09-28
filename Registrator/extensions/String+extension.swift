//
//  String+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

extension String {
    var isBackspace: Bool {
        if let char = self.cString(using: String.Encoding.utf8) {
            return strcmp(char, "\\b") == -92
        }
        return false
    }
}
