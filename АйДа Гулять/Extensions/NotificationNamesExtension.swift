//
//  NotificationNamesExtension.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 18.12.2022.
//

import Foundation


extension Notification.Name {
    static var userAuthRequire: Notification.Name {
        return .init(rawValue: "userAuthRequire")
    }
    
    static var userProfileUpdate: Notification.Name {
        return .init(rawValue: "userProfileUpdate")
    }
}
