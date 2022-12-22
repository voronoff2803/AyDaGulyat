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
            if newValue != UserDefaults.standard.string(forKey: "access_token") {
                NotificationCenter.default.post(name: .userProfileUpdate, object: nil)
            }
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
    
    func setNewPassword(newPassword: String) -> AnyPublisher<Bool, BaseError> {
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
    
    // Statics
    
    func getHobby() -> AnyPublisher<StaticHobbyQuery.Data, BaseError> {
        client.fetchPublisher(query: StaticHobbyQuery(), cachePolicy: .returnCacheDataAndFetch)
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
    
    // Pages
    
    func getPageByAlias(alias: String) -> AnyPublisher<PageByAliasQuery.Data, BaseError> {
        client.fetchPublisher(query: PageByAliasQuery(alias: GraphQLNullable.some(alias)))
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
