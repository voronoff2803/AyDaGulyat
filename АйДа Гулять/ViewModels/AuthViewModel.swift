//
//  AuthViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import Foundation
import Combine


class AuthViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    // NewPasswordViewController
    
    @Published var newPasswordFirst = ""
    @Published var newPasswordSecond = ""
    @Published var newPasswordState: NewPasswordViewController.State = .empty
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        $newPasswordFirst
            .removeDuplicates()
            .combineLatest($newPasswordSecond.removeDuplicates())
            .sink(receiveValue: {first, second in
                self.validatePasswords(first: first, second: second)
            })
            .store(in: &subscriptions)
    }
    
    func validatePasswords(first: String, second: String) {
        if first.isEmpty {
            newPasswordState = .empty
            return
        }
        
        if !Utils.isValidPassword(value: first) {
            newPasswordState = .weakPassword
            return
        }
        
        if first.isEmpty || second.isEmpty {
            newPasswordState = .empty
            return
        }
        
        if first != second {
            newPasswordState = .differentPassword
            return
        }
        
        newPasswordState = .normal
    }
}

