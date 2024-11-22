//
//  String+ extension.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 21.11.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "\(self) could not be found")
    }
}
