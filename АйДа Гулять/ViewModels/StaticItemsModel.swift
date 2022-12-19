//
//  StaticItemsModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 19.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine
import Aida

typealias StaticItem = (Aida.UUID, String)

class StaticItemsModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    enum Items {
        case hobby
    }
    
    @Published var hobbyItems: [StaticItem] = []
    
    init(requiredItems: [StaticItemsModel.Items]) {
        for item in requiredItems {
            switch item {
            case .hobby: fetchBreed()
            }
        }
    }
    
    func fetchBreed() {
        APIService.shared.getHobby()
            .sink { _ in } receiveValue: { res in
                guard let staticHobby = res.staticHobby else { return }
                self.hobbyItems = staticHobby
                    .compactMap({ $0 })
                    .map({ hobby in
                        (hobby.id, hobby.valueRu)
                    })
            }
            .store(in: &subscriptions)
    }
}
