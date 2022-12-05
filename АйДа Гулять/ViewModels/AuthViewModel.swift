//
//  AuthViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import Foundation
import Combine
import Apollo
import ApolloCombine


class AuthViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()

    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorIndicator.errors.eraseToAnyPublisher()
    }
    
    var userID = ""
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @Published var timerSeconds = 0
    
    // AuthViewController
    
    @Published var email = ""
    @Published var password = ""
    @Published var authState: AuthViewController.State = .normal
    @Published var registrationState: RegistrationViewController.State = .empty
    
    // NewPasswordViewController
    
    @Published var newPasswordSecond = ""
    @Published var newPasswordState: NewPasswordViewController.State = .normal
    
    // Code
    
    @Published var code = ""
    @Published var codeState: EmailCodeViewController.State = .codeInput
    
    // Email Forgot
    
    @Published var recoverPasswordEmailState: RecoverPasswordEmailViewController.State = .normal
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        $password
            .removeDuplicates()
            .combineLatest(
                $newPasswordSecond
                    .removeDuplicates()
            )
            .sink(receiveValue: {first, second in
                self.validatePasswords(first: first, second: second)
            })
            .store(in: &subscriptions)
        
        timer
            .sink { _ in
                if self.timerSeconds > 0 {
                    self.timerSeconds -= 1
                } else if self.codeState == .codeInput {
                    self.codeState = .requestCodeAgain
                }
            }
            .store(in: &subscriptions)
        
        $code
            .sink { value in
                if value.count >= 6 {
                    self.sendCode()
                }
            }
            .store(in: &subscriptions)
        
        $password
            .removeDuplicates()
            .combineLatest(
                $email
                    .removeDuplicates()
            )
            .sink(receiveValue: { password, email in
                self.validateEmailAndPassword(email: email, password: password)
            })
            .store(in: &subscriptions)
        
        $email
            .removeDuplicates()
            .sink(receiveValue: { email in
                self.validateEmail(email: email)
            })
            .store(in: &subscriptions)
    }
    
    func validateEmail(email: String) {
        if !Utils.isValidEmail(value: email) {
            authState = .emailWorng
            recoverPasswordEmailState = .wrongEmail
            return
        }
        
        recoverPasswordEmailState = .normal
        authState = .normal
    }
    
    func validatePasswords(first: String, second: String) {
        if !Utils.isValidPassword(value: first) {
            newPasswordState = .weakPassword
            return
        }
        
        if first != second {
            newPasswordState = .differentPassword
            return
        }
        
        newPasswordState = .normal
    }
    
    func validateEmailAndPassword(email: String, password: String) {
        if !Utils.isValidEmail(value: email) && !Utils.isValidPassword(value: password) {
            registrationState = .normal(false, false)
            return
        }
        
        if !Utils.isValidEmail(value: email) {
            registrationState = .normal(false, true)
            return
        }
        
        if !Utils.isValidPassword(value: password) {
            registrationState = .normal(true, false)
            return
        }
        
        registrationState = .normal(true, true)
    }
    
    func loginUser() {
        APIService.shared.authLoginUser(email: email, password: password)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .sink(receiveValue: { res in
                if res {
                    self.authState = .success
                }
            })
            .store(in: &subscriptions)
    }
    
    func registrationUser() {
        APIService.shared.authCreateUser(email: email, password: password)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .sink(receiveValue: { res in
                self.userID = res
                self.registrationState = .success
            })
            .store(in: &subscriptions)
    }
    
    func sendCode() {
        APIService.shared.authValidateCode(code: code, id: userID)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .sink(receiveValue: { res in
                self.codeState = .success
            })
            .store(in: &subscriptions)
    }
    
    func requestCode() {
        self.codeState = .codeInput
        timerSeconds = 120
        APIService.shared.authSendCode(id: userID)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .sink(receiveValue: { res in
                if !res {
                    self.codeState = .requestCodeAgain
                }
            })
            .store(in: &subscriptions)
    }
    
    func sendCodeEmail() {
        APIService.shared.authResetCodeSend(email: email)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .sink(receiveValue: { res in
                self.userID = res
                self.recoverPasswordEmailState = .success
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        print("deinit")
    }
}

