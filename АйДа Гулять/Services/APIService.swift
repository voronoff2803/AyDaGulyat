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
    
    private(set) lazy var client = {
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
    }
    
    var isAuthenticated: Bool {
        access_token != ""
    }
    
    //Auth
    
    func loginUser(email: String, password: String) -> AnyPublisher<Bool, GQLError> {
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
    
    
    func createUser(email: String, password: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: CreateUserMutation(email: email, password: password))
            .tryMap { res in
                guard res.data?.createUser?.success == true
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
    
    
    func resetPassword(email: String) -> AnyPublisher<Bool, GQLError> {
        client.performPublisher(mutation: ResetPasswordMutation(email: email))
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
