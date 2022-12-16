//
//  BaseError.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import Foundation


struct BaseError: Error {

    // MARK: - Instance Properties
    var isShowable: Bool = true
    var message: String
}


extension BaseError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "error")
    }
}
