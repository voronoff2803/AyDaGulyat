//
//  PersonEditViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 18.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine
import Aida


class PersonEditViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    let staticItemsModel = StaticItemsModel(requiredItems: [.hobby])
    
    @Published var selectedHobbyIds: [Aida.UUID] = []
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorIndicator.errors.eraseToAnyPublisher()
    }
    
    let coordinator: Coordinator
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        setupBindings()
    }
    
    func setupBindings() {
    }
    
    func selectHobby() {
        
    }
}
