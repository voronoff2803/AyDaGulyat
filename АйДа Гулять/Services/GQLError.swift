//
//  GQLError.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import Foundation


struct GQLError: Error {

    // MARK: - Instance Properties
    var message: String
}


extension GQLError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "error")
    }
}
