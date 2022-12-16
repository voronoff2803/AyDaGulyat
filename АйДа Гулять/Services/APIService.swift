//
//  APIService.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.11.2022.
//

import Foundation
import Apollo
import ApolloCombine
import Combine


class APIService {
    static let shared = APIService()
    private init() {}
    
    var delegate: APIServiceDelegate?
    
    var refresh_token: String {
        get {
            return UserDefaults.standard.string(forKey: "refresh_token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refresh_token")
        }
    }
    
    var access_token: String {
        get {
            return UserDefaults.standard.string(forKey: "access_token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "access_token")
        }
    }
    
    lazy var client: ApolloClient = {
        let endpointURL = URL(string: "https://aida.lol/graphql")!
        let store = ApolloStore()
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: self.interceptorProvider, endpointURL: endpointURL
        )
        
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
    
    let store = ApolloStore()
    
    lazy var interceptorProvider: NetworkInterceptorsProvider = {
        NetworkInterceptorsProvider(
            interceptors: [TokenInterceptor()],
            store: self.store
        )
    }()
    
    var isAuthenticated: Bool {
        access_token != ""
    }
    
    func processError(error: Error) -> BaseError {
        let baseError = error as? BaseError ?? BaseError(message: error.localizedDescription)
        if let delegate = delegate {
            if delegate.processError(error: baseError) {
                return BaseError(isShowable: false, message: baseError.message)
            } else {
                return baseError
            }
        }
        return baseError
    }
    
    //Auth
    
    func authLoginUser(email: String, password: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: LoginUserMutation(email: email, password: password))
            .tryMap { res in
                guard let refresh_token = res.data?.loginUser?.refreshToken,
                      let access_token = res.data?.loginUser?.accessToken
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authCreateUser(email: String, password: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: CreateUserMutation(email: email, password: password))
            .tryMap { res in
                guard res.data?.createUser?.success == true,
                      let userId = res.data?.createUser?.id
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetCodeSend(email: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: SendResetMutation(email: email))
            .tryMap { res in
                guard res.data?.sendReset?.success == true,
                      let userId = res.data?.sendReset?.id
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetPassword(newPassword: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: ResetPasswordMutation(newPassword: newPassword))
            .tryMap { res in
                guard res.data?.resetPassword?.success == true
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authSendCode(email: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: SendCodeMutation(email: GraphQLNullable.some(email)))
            .tryMap { res in
                guard res.data?.sendCode?.success == true
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return res.data?.sendCode?.id ?? ""
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func authValidateCode(code: String, id: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: ValidateCodeMutation(code: code, validateCodeId: id))
            .tryMap { res in
                guard let refresh_token = res.data?.validateCode?.refreshToken,
                      let access_token = res.data?.validateCode?.accessToken
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
//    func refreshToken() -> AnyPublisher<Bool, BaseError> {
//        client.performPublisher(mutation: RefreshTokenMutation())
//            .tryMap { res in
//                guard let access_token = res.data?.refreshToken?.accessToken
//                else {
//                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
//                }
//                self.access_token = access_token
//                return true
//            }
//            .mapError({ error in
//                self.processError(error: error)
//            })
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
//    func setNewPassword(newPassword: String) -> AnyPublisher<Bool, BaseError> {
//        client.performPublisher(mutation: ResetPasswordMutation(newPassword: newPassword))
//            .tryMap { res in
//                guard res.data?.resetPassword?.success == true
//                else {
//                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
//                }
//                return true
//            }
//            .mapError({ error in
//                self.processError(error: error)
//            })
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
        func myProfile() -> AnyPublisher<MyProfileQuery.Data, BaseError> {
            client.fetchPublisher(query: MyProfileQuery())
                .tryMap { res in
                    guard let data = res.data else {
                        throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                    }
                    return data
                }
                .mapError({ error in
                    self.processError(error: error)
                })
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
}


protocol APIServiceDelegate {
    func processError(error: BaseError) -> Bool
}
