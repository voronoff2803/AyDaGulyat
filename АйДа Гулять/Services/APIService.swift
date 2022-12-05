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
    
    private var refresh_token: String {
        get {
            return UserDefaults.standard.string(forKey: "refresh_token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refresh_token")
        }
    }
    
    private var access_token: String {
        get {
            return UserDefaults.standard.string(forKey: "access_token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "access_token")
        }
    }
    
    private(set) lazy var client: ApolloClient = {
        let endpointURL = URL(string: "https://aida.lol/graphql")!
        let store = ApolloStore()
        let interceptorProvider = NetworkInterceptorsProvider(
            interceptors: [TokenInterceptor(token: self.access_token)],
            store: store
        )
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider, endpointURL: endpointURL
        )
        
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
    
    var isAuthenticated: Bool {
        access_token != ""
    }
    
    //Auth
    
    func authLoginUser(email: String, password: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: LoginUserMutation(email: email, password: password))
            .tryMap { res in
                guard let refresh_token = res.data?.loginUser?.refreshToken,
                      let access_token = res.data?.loginUser?.accessToken
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authCreateUser(email: String, password: String) -> AnyPublisher<String, GQLError> {
        client.performPublisher(mutation: CreateUserMutation(email: email, password: password))
            .tryMap { res in
                guard res.data?.createUser?.success == true,
                      let userId = res.data?.createUser?.id
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetCodeSend(email: String) -> AnyPublisher<String, GQLError> {
        client.performPublisher(mutation: SendResetMutation(email: email))
            .tryMap { res in
                guard res.data?.sendReset?.success == true,
                      let userId = res.data?.sendReset?.id
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetPassword(newPassword: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: ResetPasswordMutation(newPassword: newPassword))
            .tryMap { res in
                guard res.data?.resetPassword?.success == true
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return true
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authSendCode(id: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: SendCodeMutation(id: GraphQLNullable.some(id)))
            .tryMap { res in
                guard res.data?.sendCode?.success == true
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return true
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func authValidateCode(code: String, id: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: ValidateCodeMutation(code: code, validateCodeId: id))
            .tryMap { res in
                guard let refresh_token = res.data?.validateCode?.refreshToken,
                      let access_token = res.data?.validateCode?.accessToken
                else {
                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                return error as? GQLError ?? GQLError(message: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //    func myProfile() -> AnyPublisher<MyProfileQuery.Data, GQLError> {
    //        client.fetchPublisher(query: MyProfileQuery())
    //            .tryMap { res in
    //                guard let data = res.data else {
    //                    throw GQLError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
    //                }
    //                return data
    //            }
    //            .mapError({ error in
    //                return error as? GQLError ?? GQLError(message: error.localizedDescription)
    //            })
    //            .receive(on: DispatchQueue.main)
    //            .eraseToAnyPublisher()
    //    }
}
