//
//  TokenInterceptor.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.11.2022.
//

import Foundation
import Apollo


class TokenInterceptor: ApolloInterceptor {
    var token: String {
        get {
            APIService.shared.access_token
        }
    }
    
    var refreshToken: String {
        get {
            APIService.shared.refresh_token
        }
    }
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
            if token != "" {
                request.addHeader(name: "Authorization", value: "Bearer \(token)")
            }
            if request.operation is RefreshTokenMutation {
                request.addHeader(name: "Authorization", value: "Bearer \(refreshToken)")
            }
            chain.proceedAsync(request: request, response: response, completion: completion)
        }
}


class NetworkInterceptorsProvider: DefaultInterceptorProvider {
    let interceptors: [ApolloInterceptor]
    
    init(interceptors: [ApolloInterceptor], store: ApolloStore) {
        self.interceptors = interceptors
        super.init(store: store)
    }
    
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        self.interceptors.forEach { interceptor in
            interceptors.insert(interceptor, at: 0)
        }
        
        if !(operation is RefreshTokenMutation) {
            interceptors.append(
                RefreshBearerTokenInterceptor()
            )
        }
        
        return interceptors
    }
}


class RefreshBearerTokenInterceptor: ApolloInterceptor {
    let client = APIService.shared.client
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        guard let error = response?.parsedResponse?.errors?.first else {
            chain.proceedAsync(request: request, response: response, completion: completion)
            return
        }
        
        print("============\(error.message)============")
        
        guard error.message == "ErrorCodes.JWT_EXPIRED" else {
            chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            return
        }
        
        let refreshToken = APIService.shared.refresh_token
        
        guard refreshToken != "" else {
            chain.handleErrorAsync(
                BaseError(message: "Refresh Token Empty"),
                request: request,
                response: response,
                completion: completion
            )
            return
        }
        
        client.perform(mutation: RefreshTokenMutation(), publishResultToStore: false) { res in
            switch res {
            case let .failure(error):
                chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            case let .success(result):
                APIService.shared.access_token = result.data?.refreshToken?.accessToken ?? ""
                chain.retry(request: request, completion: completion)
            }
        }
    }
}


// Проверить восстанавление пасса
// Добавить экран мой профиль по МВВМ
// 
