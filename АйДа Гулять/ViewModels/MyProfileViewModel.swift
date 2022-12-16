//
//  MyProfileViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//


import Foundation
import Combine
import Apollo
import ApolloCombine


class MyProfileViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    @Published var firstName = ""
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        APIService.shared.myProfile()
            .sink { req in
                switch req {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { res in
                print(res)
            }
            .store(in: &subscriptions)
    }
}
