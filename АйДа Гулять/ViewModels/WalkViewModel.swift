//
//  WalkViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 26.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine


class WalkViewModel: NSObject, ObservableObject {
    enum State {
        case normal
        case play
        case pause
    }
    
    var subscriptions = Set<AnyCancellable>()
    let coordinator: Coordinator
    
    @Published var startTime: Date = Date()
    @Published var timeInterval: TimeInterval = TimeInterval()
    
    var currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    
    @Published var state: WalkViewModel.State = .normal
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        self.setupBindings()
    }
    
    func setupBindings() {
        currentTimePublisher.sink { _ in
            self.timeInterval = -self.startTime.timeIntervalSinceNow
        }
        .store(in: &subscriptions)
    }
    
    func startWalk() {
        state = .play
        startTime = Date()
        currentTimePublisher.connect().store(in: &subscriptions)
        self.timeInterval = -self.startTime.timeIntervalSinceNow
    }
    
    func stopWalk() {
        state = .normal
    }
}

