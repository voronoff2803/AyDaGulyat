//
//  TimeInterval.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 26.12.2022.
//

import Foundation


extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    var seconds: Int {
        return Int(self) % 60
    }

    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    var hours: Int {
        return Int(self) / 3600
    }
}
